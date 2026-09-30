"""Hold ONE yaw for a run of frames (a walk cycle the original rendered from a fixed camera) and re-fit the rest.

  py tmp/yaw_const.py <family> <nn,nn,...> score <yaw,yaw,...>   -> mean IoU / dE / look score per candidate yaw
                                                                  (the other pose params as fitted)
  py tmp/yaw_const.py <family> <nn,nn,...> set <yaw>             -> writes yaw into fit.json for those frames and
                                                                  re-optimises them with yaw FROZEN (optimfail
                                                                  fidelity: reseed, probes, shift hops, descent)"""
import json
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

fam, nns, cmd = sys.argv[1], [int(x) for x in sys.argv[2].split(",")], sys.argv[3]
cfg = fm.load_cfg(fam)
fp = os.path.join(fm.workdir(fam), "fit.json")
with open(fp, "r", encoding="utf-8") as fh:
    fit = json.load(fh)
frames = [f for f in fm.base_frames(cfg) if f[0] in nns]

if cmd == "score":
    yaws = [float(x) for x in sys.argv[4].split(",")]
    base = fm._opts(fam, cfg)
    lfo = fm._look_frame_opts(fam)
    trials = []
    for y in [None] + yaws:
        for fr in frames:
            p = dict(fit["frames"][str(fr[0])]["pose"])
            if y is not None:
                p["yaw"] = y
            trials.append(((y, fr[0]), fr, p, dict(fm.frame_opts(cfg, fr[0], base=base), **lfo.get(str(fr[0]), {}))))
    d = fm.workdir(fam, "yawconst")
    s = cfg["scale"]
    sc = fm._render_score(cfg, fit, trials, d, "%s_yc" % fam, s, 64)
    for y in [None] + yaws:
        ious, des = [], []
        for k, (tid, fr, p, o) in enumerate(trials):
            if tid[0] != y:
                continue
            out = os.path.join(d, "%s_yc_%05d.png" % (fam, k))
            sd = fm.premul(fm.rgba(fr[1]))
            r = fm.box_down(fm.premul(fm.rgba(out)), s)
            ious.append(fm.compare(sd, r)[0])
            des.append(fm.compare_blur(sd, r))
        tot = [sc[(y, fr[0])] for fr in frames]
        print("yaw %-6s IoU mean %.3f min %.3f  dE mean %.2f max %.2f  score mean %.2f" % (
            "fitted" if y is None else "%g" % y, sum(ious) / len(ious), min(ious), sum(des) / len(des), max(des),
            sum(tot) / len(tot)))
elif cmd == "set":
    y = float(sys.argv[4])
    order = [f[0] for f in fm.base_frames(cfg)]
    near = set()                         # optim's reseed copies a +-2 neighbour's WHOLE pose: hold theirs too
    for nn in nns:
        i = order.index(nn)
        near.update(order[max(0, i - 2):i + 3])
    keep = {nn: dict(fit["frames"][str(nn)]["pose"]) for nn in near - set(nns)}
    for nn in near:
        fit["frames"][str(nn)]["pose"]["yaw"] = y
    with open(fp, "w", encoding="utf-8") as fh:
        json.dump(fit, fh, indent=1)
    op = dict(cfg["optim"])
    op["params"] = {k: v for k, v in op["params"].items() if k != "yaw"}
    op["probe"] = [{k: v for k, v in pr.items() if k != "yaw"} for pr in (op.get("probe") or [])]
    op["probe"] = [pr for pr in op["probe"] if pr]
    fm.stage_optim(fam, dict(cfg, optim=op), only=nns)
    with open(fp, "r", encoding="utf-8") as fh:
        fit = json.load(fh)
    for nn, p in keep.items():
        fit["frames"][str(nn)]["pose"] = p
    with open(fp, "w", encoding="utf-8") as fh:
        json.dump(fit, fh, indent=1)
    print("yaw after optim:", {fr[0]: fit["frames"][str(fr[0])]["pose"]["yaw"] for fr in frames})
