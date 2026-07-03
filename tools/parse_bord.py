#!/usr/bin/env python3
"""First-pass decoder for Step On It! level (`BORD`) resources.

Reads the classic Mac resource fork out of an AppleDouble (`._*`) file,
enumerates all resources, extracts the `BORD` resources, and prints a
structural analysis of one board to help reverse the byte layout.

Usage:
    python tools/parse_bord.py ["path/to/._SOI Boards"] [out_dir]
"""
from __future__ import annotations

import struct
import sys
from pathlib import Path

DEFAULT_SRC = Path("raw_game") / "Step On It\u2122" / "__MACOSX" / "._SOI Boards"
DEFAULT_OUT = Path("extracted") / "levels"

APPLEDOUBLE_MAGIC = 0x00051607
ENTRY_RESOURCE_FORK = 2


def read_resource_fork(path: Path) -> bytes:
    """Return the raw resource-fork bytes from an AppleDouble container."""
    data = path.read_bytes()
    magic, version = struct.unpack_from(">II", data, 0)
    if magic != APPLEDOUBLE_MAGIC:
        # Not AppleDouble; assume the file *is* the resource fork already.
        return data
    (num_entries,) = struct.unpack_from(">H", data, 24)
    for i in range(num_entries):
        entry_id, offset, length = struct.unpack_from(">III", data, 26 + i * 12)
        if entry_id == ENTRY_RESOURCE_FORK:
            return data[offset:offset + length]
    raise ValueError("No resource fork entry found in AppleDouble file")


def parse_resource_fork(rf: bytes) -> dict[str, list[dict]]:
    """Parse a Mac resource fork into {type: [{id, name, data}, ...]}."""
    data_off, map_off, data_len, map_len = struct.unpack_from(">IIII", rf, 0)

    # Resource map: skip the 16-byte header copy + 4 (next handle) + 2 (ref) + 2 (attrs)
    type_list_off = map_off + struct.unpack_from(">H", rf, map_off + 24)[0]
    name_list_off = map_off + struct.unpack_from(">H", rf, map_off + 26)[0]

    (num_types_minus_1,) = struct.unpack_from(">H", rf, type_list_off)
    num_types = num_types_minus_1 + 1

    out: dict[str, list[dict]] = {}
    for t in range(num_types):
        base = type_list_off + 2 + t * 8
        res_type = rf[base:base + 4].decode("mac_roman")
        count = struct.unpack_from(">H", rf, base + 4)[0] + 1
        ref_off = type_list_off + struct.unpack_from(">H", rf, base + 6)[0]

        entries = []
        for r in range(count):
            rbase = ref_off + r * 12
            res_id, name_off = struct.unpack_from(">hH", rf, rbase)
            data_ptr_hi, data_ptr_lo = struct.unpack_from(">BH", rf, rbase + 5)
            data_ptr = (data_ptr_hi << 16) | data_ptr_lo

            abs_data = data_off + data_ptr
            (res_len,) = struct.unpack_from(">I", rf, abs_data)
            res_data = rf[abs_data + 4:abs_data + 4 + res_len]

            name = ""
            if name_off != 0xFFFF:
                nptr = name_list_off + name_off
                nlen = rf[nptr]
                name = rf[nptr + 1:nptr + 1 + nlen].decode("mac_roman")

            entries.append({"id": res_id, "name": name, "data": res_data})
        out[res_type] = entries
    return out


def hexdump(data: bytes, start: int = 0, length: int | None = None) -> None:
    end = len(data) if length is None else min(len(data), start + length)
    for off in range(start, end, 16):
        chunk = data[off:off + 16]
        hexs = " ".join(f"{b:02X}" for b in chunk)
        text = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
        print(f"  {off:04X}  {hexs:<47}  {text}")


DATA_MARKER = b"DATA: "


def analyze_board(entry: dict) -> None:
    data = entry["data"]
    print(f"\n=== BORD id={entry['id']} name={entry['name']!r} len={len(data)} ===")
    hexdump(data, 0, len(data))

    marker = data.find(DATA_MARKER)
    print(f"\n  'DATA: ' marker at offset: {marker}")
    if marker >= 0:
        header = data[:marker]
        body = data[marker + len(DATA_MARKER):]
        print(f"  header bytes ({len(header)}): {header.hex(' ')}")
        # Post-marker: leading words, then 64 64-delimited records.
        records = body.split(b"\x64\x64")
        print(f"  body split on 64 64 -> {len(records)} chunk(s):")
        for i, rec in enumerate(records):
            print(f"    [{i:02d}] len={len(rec):3d}  {rec.hex(' ')}")


def scan_all(boards: list[dict]) -> None:
    print("\n--- 'DATA: ' marker scan across all boards ---")
    have = 0
    marker_offsets = {}
    for e in boards:
        off = e["data"].find(DATA_MARKER)
        if off >= 0:
            have += 1
            marker_offsets[off] = marker_offsets.get(off, 0) + 1
    print(f"  boards containing 'DATA: ': {have}/{len(boards)}")
    print(f"  marker offset histogram (offset: count): {dict(sorted(marker_offsets.items()))}")


def main() -> None:
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_SRC
    out_dir = Path(sys.argv[2]) if len(sys.argv) > 2 else DEFAULT_OUT

    rf = read_resource_fork(src)
    print(f"Resource fork: {len(rf)} bytes from {src}")

    resources = parse_resource_fork(rf)
    print("\nResource types found:")
    for rtype, entries in resources.items():
        ids = [e["id"] for e in entries]
        print(f"  {rtype!r}: {len(entries)} resource(s), ids={ids}")

    boards = resources.get("BORD", [])
    if not boards:
        print("\nNo BORD resources found.")
        return

    out_dir.mkdir(parents=True, exist_ok=True)
    for e in boards:
        (out_dir / f"board_{e['id']:03d}.bord").write_bytes(e["data"])
    print(f"\nExtracted {len(boards)} BORD resource(s) -> {out_dir}")

    # Analyze the lowest-id board and the sizes of all boards.
    boards_sorted = sorted(boards, key=lambda e: e["id"])
    print("\nBoard sizes:", [(e["id"], len(e["data"])) for e in boards_sorted])
    scan_all(boards)
    # Demo board (oracle trace source) and the smallest board (clearest structure).
    by_id = {e["id"]: e for e in boards}
    if 301 in by_id:
        analyze_board(by_id[301])
    smallest = min(boards, key=lambda e: len(e["data"]))
    analyze_board(smallest)


if __name__ == "__main__":
    main()
