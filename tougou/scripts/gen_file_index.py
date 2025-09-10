#!/usr/bin/env python3
"""Generate AUTO section in docs/reference/file-index.md.

Extract first comment block (/* ... */) as summary for each *.s file.
Markers: <!-- AUTO-FILES:BEGIN --> ... <!-- AUTO-FILES:END -->
"""
from __future__ import annotations
import pathlib, re, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
TARGET = ROOT / "docs" / "reference" / "file-index.md"
SRC_DIRS = ["init", "display", "game", "input", "sound"]

def summarize(path: pathlib.Path) -> str:
    text = path.read_text(encoding='utf-8', errors='ignore').splitlines()
    block = []
    in_block = False
    for line in text:
        if line.strip().startswith("/*"):
            in_block = True
        if in_block:
            block.append(line)
            if line.strip().endswith("*/"):
                break
        elif line.strip() == "":
            break
    cleaned = []
    for l in block:
        l = re.sub(r"^[/*\-\s]+", "", l)
        if l:
            cleaned.append(l)
    return cleaned[0][:120] if cleaned else "(no summary)"

def collect():
    rows = []
    for d in SRC_DIRS:
        base = ROOT / d
        if not base.exists():
            continue
        for f in sorted(base.glob("*.s")):
            rows.append((d, f.relative_to(ROOT).as_posix(), summarize(f)))
    return rows

def build_table(rows):
    out = ["### 自動生成ファイル索引", "", "| モジュール | パス | 概要 |", "|-----------|------|------|"]
    for mod, rel, summ in rows:
        out.append(f"| {mod} | {rel} | {summ} |")
    out.append("")
    return "\n".join(out)

def replace_block(text: str, new_block: str) -> str:
    begin = "<!-- AUTO-FILES:BEGIN -->"; end = "<!-- AUTO-FILES:END -->"
    if begin in text and end in text:
        return re.sub(f"{begin}.*?{end}", f"{begin}\n{new_block}\n{end}", text, flags=re.DOTALL)
    return text.rstrip() + f"\n\n{begin}\n{new_block}\n{end}\n"

def main():
    rows = collect()
    table = build_table(rows)
    original = TARGET.read_text(encoding='utf-8')
    updated = replace_block(original, table)
    if updated != original:
        TARGET.write_text(updated, encoding='utf-8')
        print("[OK] file-index.md updated")
    else:
        print("[OK] file-index.md unchanged")
    return 0

if __name__ == "__main__":
    sys.exit(main())
