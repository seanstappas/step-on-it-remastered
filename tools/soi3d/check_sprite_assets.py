#!/usr/bin/env python3
"""check_sprite_assets.py -- completeness gate for a remastered sprite family.

Verifies a family under extracted/sprites_3d/<family>/ has EVERYTHING the standard layout requires
(process doc sec.5b): the per-dir meta.json, the still(s), the 3D model (.glb), the builder module that
generates it, and the _verify artefacts -- image compare (cmp.png), angle/positioning guide, and the
2D-vs-3D gif + mp4. Then, if meta.json declares a `baseline`, it RUNS tools/soi3d/verify_3d.py (source
frame vs published still) and reports the fidelity metrics (writing the cmp.png overlay).

Motion-aware: static props (meta motion=="static" or static==true) don't need the animation/angle
artefacts. Pending models (model_status starting "pending", e.g. the P1 GLB export) are reported as
PENDING, not a hard failure -- unless --strict.

Usage:
  py tools/soi3d/check_sprite_assets.py <family>            # one family, e.g. disk_sprites
  py tools/soi3d/check_sprite_assets.py --all               # every family under the root
  py tools/soi3d/check_sprite_assets.py <family> --strict   # PENDING counts as failure
  [--no-verify]  [--root extracted/sprites_3d]  [--tools tools/soi3d]
Exit code 0 = all required assets present; 1 = something missing (or PENDING under --strict).
"""
import argparse
import glob
import json
import os
import subprocess
import sys

OK, MISS, PEND, WARN, SUB = "[ OK ]", "[MISS]", "[PEND]", "[WARN]", "      "


def _isfile(p):
    return os.path.isfile(p)


def _verify(fam_dir, vdir, meta, stills, tools, rows):
    """Run tools/soi3d/verify_3d.py against the meta 'baseline' (source frame vs published still)."""
    base = meta.get("baseline")
    if not base:
        rows.append((WARN, "verify_3d", "no 'baseline' in meta.json -> add baseline:{source,still,flags} to enable"))
        return
    src = base.get("source")
    still = os.path.join(fam_dir, base.get("still") or (stills[0] if stills else ""))
    if not (src and _isfile(src) and _isfile(still)):
        rows.append((WARN, "verify_3d", "baseline source/still not found (src=%s)" % src))
        return
    os.makedirs(vdir, exist_ok=True)
    out = os.path.join(vdir, "cmp.png")
    cmd = [sys.executable, os.path.join(tools, "verify_3d.py"), src, still] + list(base.get("flags", [])) + ["--out", out]
    try:
        res = subprocess.run(cmd, capture_output=True, text=True, timeout=240)
    except Exception as e:  # noqa: BLE001
        rows.append((WARN, "verify_3d", "could not run: %s" % e))
        return
    flagged = [ln for ln in res.stdout.splitlines() if "<--" in ln or "grey rim!" in ln]
    if res.returncode != 0:
        rows.append((WARN, "verify_3d", "exited %d: %s" % (res.returncode, res.stderr.strip()[:120])))
    elif flagged:
        rows.append((WARN, "verify_3d", "%d metric(s) flagged (see %s)" % (len(flagged), out)))
        for ln in flagged:
            rows.append((SUB, ln.strip(), ""))
    else:
        rows.append((OK, "verify_3d", "metrics within tolerance -> " + out))


def check_family(fam, root, tools, run_verify):
    fam_dir = os.path.join(root, fam)
    meta_path = os.path.join(fam_dir, "meta.json")
    if not _isfile(meta_path):
        return [(MISS, "meta.json", meta_path)], 1, 0
    with open(meta_path, encoding="utf-8") as f:
        meta = json.load(f)
    rows = [(OK, "meta.json", "")]
    errors = pend = 0

    motion = str(meta.get("motion", "")).lower()
    static = bool(meta.get("static")) or "static" in motion
    animated = not static

    # 1. builder module that GENERATES the assets (by CLI mode)
    mode = meta.get("mode")
    if not mode:
        rows.append((MISS, "meta.mode", 'add "mode":"<cli-mode>" so the builder can be found'))
        errors += 1
    else:
        bpath = os.path.join(tools, "builders", mode + ".py")
        if _isfile(bpath):
            reg = ('@register("%s")' % mode) in open(bpath, encoding="utf-8").read()
            rows.append((OK if reg else WARN, "builder %s" % bpath,
                         "" if reg else 'missing @register("%s")' % mode))
        else:
            rows.append((MISS, "builder %s" % bpath, "create it (drop-a-file; no shared edit)"))
            errors += 1

    # 2. published still(s)
    stills = meta.get("stills") or []
    if not stills:
        rows.append((MISS, "stills", "meta.stills is empty"))
        errors += 1
    for s in stills:
        ok = _isfile(os.path.join(fam_dir, s))
        rows.append((OK if ok else MISS, "still %s" % s, "" if ok else "not found"))
        errors += 0 if ok else 1

    # 3. the 3D model file
    model = meta.get("model")
    if model:
        p = os.path.join(fam_dir, model)
        if _isfile(p):
            rows.append((OK, "model %s" % model, ""))
        elif str(meta.get("model_status", "")).startswith("pending"):
            rows.append((PEND, "model %s" % model, "pending (%s)" % meta.get("model_status")))
            pend += 1
        else:
            rows.append((MISS, "model %s" % model, "not found"))
            errors += 1
    elif static:
        rows.append((OK, "model", "n/a (static prop)"))
    else:
        rows.append((WARN, "model", "no model declared for an animated prop"))

    # 4. run verify_3d (creates cmp.png) BEFORE the _verify presence checks
    vdir = os.path.join(fam_dir, "_verify")
    if run_verify:
        _verify(fam_dir, vdir, meta, stills, tools, rows)

    # 5. _verify artefacts: image compare always; angle + gif + mp4 for animated props
    required = ["cmp.png"] + (["positioning.png", "2d_vs_3d.gif", "2d_vs_3d.mp4"] if animated else [])
    for name in required:
        ok = _isfile(os.path.join(vdir, name))
        rows.append((OK if ok else MISS, "_verify/%s" % name, "" if ok else "not found"))
        errors += 0 if ok else 1
    vv = _isfile(os.path.join(vdir, "vs_video.png"))
    rows.append((OK if vv else WARN, "_verify/vs_video.png",
                 "" if vv else "optional (only if the prop appears in refs/videos)"))

    return rows, errors, pend


def main():
    ap = argparse.ArgumentParser(description="Completeness gate for a remastered sprite family.")
    ap.add_argument("family", nargs="?", help="family folder name (e.g. disk_sprites); or use --all")
    ap.add_argument("--all", action="store_true", help="check every family under the root")
    ap.add_argument("--strict", action="store_true", help="treat PENDING (e.g. the P1 model) as a failure")
    ap.add_argument("--no-verify", action="store_true", help="skip running verify_3d")
    ap.add_argument("--root", default="extracted/sprites_3d")
    ap.add_argument("--tools", default="tools/soi3d")
    a = ap.parse_args()

    if a.all:
        fams = sorted(os.path.basename(os.path.dirname(p))
                      for p in glob.glob(os.path.join(a.root, "*", "meta.json")))
    elif a.family:
        fams = [a.family]
    else:
        ap.error("give a <family> or --all")

    total_fail = 0
    for fam in fams:
        rows, errs, pend = check_family(fam, a.root, a.tools, not a.no_verify)
        print("\n=== %s ===" % fam)
        for status, label, detail in rows:
            print("  %s %s%s" % (status, label, ("  -- " + detail) if detail else ""))
        bad = errs + (pend if a.strict else 0)
        print("  -> %s  (%d missing, %d pending)" % ("COMPLETE" if bad == 0 else "INCOMPLETE", errs, pend))
        total_fail += bad

    print("\n%s: %d family(ies), %d issue(s)%s" %
          ("FAIL" if total_fail else "PASS", len(fams), total_fail,
           "" if total_fail else " -- all required assets present"))
    sys.exit(1 if total_fail else 0)


if __name__ == "__main__":
    main()
