#!/usr/bin/env python3
"""Enumerate a classic Mac resource fork (AppleDouble `._*` or raw fork).

Prints a type/id/name inventory and decodes a few human-readable resource
types (`vers`, `STR `, `STR#`, `SIZE`) when present.

Usage:
    python tools/rezfork.py "path/to/._SomeFile" [--decode]
"""
from __future__ import annotations

import struct
import sys
from pathlib import Path

APPLEDOUBLE_MAGIC = 0x00051607
ENTRY_RESOURCE_FORK = 2


def read_resource_fork(path: Path) -> bytes:
    data = path.read_bytes()
    if len(data) >= 4 and struct.unpack_from(">I", data, 0)[0] == APPLEDOUBLE_MAGIC:
        (num_entries,) = struct.unpack_from(">H", data, 24)
        for i in range(num_entries):
            entry_id, offset, length = struct.unpack_from(">III", data, 26 + i * 12)
            if entry_id == ENTRY_RESOURCE_FORK:
                return data[offset:offset + length]
        raise ValueError("No resource fork entry in AppleDouble file")
    return data  # assume the file is already a raw resource fork


def parse_resource_fork(rf: bytes) -> dict[str, list[dict]]:
    data_off, map_off, _dlen, _mlen = struct.unpack_from(">IIII", rf, 0)
    type_list_off = map_off + struct.unpack_from(">H", rf, map_off + 24)[0]
    name_list_off = map_off + struct.unpack_from(">H", rf, map_off + 26)[0]
    (num_types,) = struct.unpack_from(">H", rf, type_list_off)
    num_types += 1

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
            hi, lo = struct.unpack_from(">BH", rf, rbase + 5)
            abs_data = data_off + ((hi << 16) | lo)
            (res_len,) = struct.unpack_from(">I", rf, abs_data)
            res_data = rf[abs_data + 4:abs_data + 4 + res_len]
            name = ""
            if name_off != 0xFFFF:
                nptr = name_list_off + name_off
                name = rf[nptr + 1:nptr + 1 + rf[nptr]].decode("mac_roman")
            entries.append({"id": res_id, "name": name, "data": res_data})
        out[res_type] = entries
    return out


def pstr(data: bytes, off: int) -> tuple[str, int]:
    n = data[off]
    return data[off + 1:off + 1 + n].decode("mac_roman"), off + 1 + n


def decode_vers(data: bytes) -> str:
    # vers: 1 byte major(BCD), 1 minor, 1 stage, 1 non-rel, 2 region, then 2 pstrings
    short, off = pstr(data, 6)
    long_, _ = pstr(data, off)
    return f"short={short!r} long={long_!r}"


def decode_strn(data: bytes) -> list[str]:
    (count,) = struct.unpack_from(">H", data, 0)
    off = 2
    out = []
    for _ in range(count):
        s, off = pstr(data, off)
        out.append(s)
    return out


def main() -> None:
    if len(sys.argv) < 2:
        print(__doc__)
        return
    path = Path(sys.argv[1])
    decode = "--decode" in sys.argv[2:]
    rf = read_resource_fork(path)
    print(f"Resource fork: {len(rf)} bytes from {path}\n")
    res = parse_resource_fork(rf)

    print("Type inventory (type: count | ids):")
    for rtype, entries in sorted(res.items()):
        ids = [e["id"] for e in entries]
        named = [f"{e['id']}:{e['name']!r}" for e in entries if e["name"]]
        shown = ids if len(ids) <= 24 else ids[:24] + ["..."]
        print(f"  {rtype!r:8}: {len(entries):3} | {shown}")
        if named:
            print(f"           names: {named[:16]}")

    if decode:
        for e in res.get("vers", []):
            try:
                print(f"\nvers {e['id']}: {decode_vers(e['data'])}")
            except Exception as ex:  # noqa: BLE001
                print(f"\nvers {e['id']}: <decode error {ex}>")
        for e in res.get("STR ", []):
            try:
                s, _ = pstr(e["data"], 0)
                print(f"STR  {e['id']} {e['name']!r}: {s!r}")
            except Exception:  # noqa: BLE001
                pass
        for e in res.get("STR#", []):
            try:
                items = decode_strn(e["data"])
                print(f"STR# {e['id']} {e['name']!r}: {items}")
            except Exception:  # noqa: BLE001
                pass


if __name__ == "__main__":
    main()
