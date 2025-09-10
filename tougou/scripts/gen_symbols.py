#!/usr/bin/env python3
"""Generate (refresh) AUTO section in docs/reference/symbols.md.

Process:
 1. Scan *.s under module source dirs.
 2. Collect tokens declared by ".global" / ".globl".
 3. Build a markdown table grouped by module.
 4. Replace content between markers:
      <!-- AUTO-SYMBOLS:BEGIN --> ... <!-- AUTO-SYMBOLS:END -->

Idempotent: only enclosed block updated. Manual section above kept.
"""
from __future__ import annotations
import re, pathlib, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
DOC = ROOT / "docs" / "reference" / "symbols.md"
SRC_DIRS = ["init", "display", "game", "input", "sound"]
RE_GLOB = re.compile(r"^\s*\.glob(?:al|l)\s+(.*)$")

def extract():
    entries = []  # (module, rel, symbol)
    for d in SRC_DIRS:
        base = ROOT / d
        if not base.exists():
            continue
        for path in base.rglob("*.s"):
            rel = path.relative_to(ROOT).as_posix()
            mod = d
            for line in path.read_text(encoding='utf-8', errors='ignore').splitlines():
                m = RE_GLOB.match(line)
                if not m:
                    continue
                raw = m.group(1)
                for tok in re.split(r"[\s,]+", raw):
                    tok = tok.strip()
                    if not tok or tok.startswith('@'):
                        continue
                    if not re.match(r"[A-Za-z_][A-Za-z0-9_]*$", tok):  # skip constants etc
                        continue
                    entries.append((mod, rel, tok))
    return entries

def build_table(entries):
    lines = []
    lines.append("### 自動抽出シンボル一覧")
    lines.append("")
    lines.append("| モジュール | ファイル | シンボル | 備考 |")
    lines.append("|-----------|---------|---------|------|")
    for mod, rel, sym in sorted(entries, key=lambda x: (x[0], x[1], x[2])):
        note = "エントリーポイント" if sym == "_start" else ""
        lines.append(f"| {mod} | {rel} | {sym} | {note} |")
    lines.append("")
    return "\n".join(lines)

def replace_block(text: str, new_block: str) -> str:
    begin = "<!-- AUTO-SYMBOLS:BEGIN -->"
    end = "<!-- AUTO-SYMBOLS:END -->"
    if begin in text and end in text:
        return re.sub(f"{begin}.*?{end}", f"{begin}\n{new_block}\n{end}", text, flags=re.DOTALL)
    return text.rstrip() + f"\n\n{begin}\n{new_block}\n{end}\n"

def main():
    entries = extract()
    table = build_table(entries)
    content = DOC.read_text(encoding='utf-8')
    updated = replace_block(content, table)
    if updated != content:
        DOC.write_text(updated, encoding='utf-8')
        print("[OK] symbols.md updated")
    else:
        print("[OK] symbols.md unchanged")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
