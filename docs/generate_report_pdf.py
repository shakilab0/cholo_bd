#!/usr/bin/env python3
"""Generate PROJECT_REPORT.pdf from PROJECT_REPORT.md for university submission."""

from __future__ import annotations

import re
import sys
from pathlib import Path

try:
    from fpdf import FPDF
except ImportError:
    print("Installing fpdf2...")
    import subprocess

    subprocess.check_call([sys.executable, "-m", "pip", "install", "fpdf2", "-q"])
    from fpdf import FPDF

DOCS = Path(__file__).resolve().parent
MD_PATH = DOCS / "PROJECT_REPORT.md"
PDF_PATH = DOCS / "PROJECT_REPORT.pdf"


class ReportPDF(FPDF):
    def header(self):
        if self.page_no() > 1:
            self.set_font("Helvetica", "I", 8)
            self.set_text_color(100, 100, 100)
            self.cell(0, 8, "Cholo BD (Smart Travel BD) - Project Report", align="C")
            self.ln(4)

    def footer(self):
        self.set_y(-15)
        self.set_font("Helvetica", "I", 8)
        self.set_text_color(120, 120, 120)
        self.cell(0, 10, f"Page {self.page_no()}", align="C")


def strip_md(text: str) -> str:
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
    text = re.sub(r"`([^`]+)`", r"\1", text)
    text = re.sub(r"\*\*([^*]+)\*\*", r"\1", text)
    text = re.sub(r"\*([^*]+)\*", r"\1", text)
    text = text.replace("&lt;", "<").replace("&gt;", ">")
    return text.strip()


def parse_markdown(path: Path) -> list[tuple[str, str]]:
    """Return list of (block_type, content). Types: title, h1, h2, h3, body, table, hr, bullet."""
    lines = path.read_text(encoding="utf-8").splitlines()
    blocks: list[tuple[str, str]] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.strip() == "---":
            blocks.append(("hr", ""))
            i += 1
            continue
        if line.startswith("# ") and not line.startswith("## "):
            blocks.append(("title", strip_md(line[2:])))
            i += 1
            continue
        if line.startswith("## "):
            blocks.append(("h1", strip_md(line[3:])))
            i += 1
            continue
        if line.startswith("### "):
            blocks.append(("h2", strip_md(line[4:])))
            i += 1
            continue
        if line.startswith("|") and i + 1 < len(lines) and lines[i + 1].startswith("|"):
            table_lines = []
            while i < len(lines) and lines[i].startswith("|"):
                if not re.match(r"^\|[\s\-:|]+\|$", lines[i].strip()):
                    table_lines.append(lines[i])
                i += 1
            blocks.append(("table", "\n".join(table_lines)))
            continue
        if line.startswith("- ") or line.startswith("* "):
            bullets = []
            while i < len(lines) and (
                lines[i].startswith("- ") or lines[i].startswith("* ")
            ):
                bullets.append(strip_md(lines[i][2:]))
                i += 1
            blocks.append(("bullet", "\n".join(bullets)))
            continue
        if line.strip().startswith("```"):
            i += 1
            code = []
            while i < len(lines) and not lines[i].strip().startswith("```"):
                code.append(lines[i])
                i += 1
            if i < len(lines):
                i += 1
            blocks.append(("code", "\n".join(code)))
            continue
        if line.strip():
            para = [line]
            i += 1
            while i < len(lines) and lines[i].strip() and not lines[i].startswith("#"):
                if lines[i].startswith("|") or lines[i].startswith("- "):
                    break
                if lines[i].strip() == "---":
                    break
                para.append(lines[i])
                i += 1
            blocks.append(("body", strip_md(" ".join(para))))
            continue
        i += 1
    return blocks


def reset_x(pdf: ReportPDF) -> None:
    pdf.set_x(pdf.l_margin)


def render_table(pdf: ReportPDF, raw: str) -> None:
    rows = []
    for line in raw.splitlines():
        cells = [c.strip() for c in line.strip("|").split("|")]
        rows.append(cells)
    if not rows:
        return
    col_count = max(len(r) for r in rows)
    page_w = pdf.epw
    col_widths = [page_w / col_count] * col_count
    # Wider first column for 2-column key-value tables
    if col_count == 2:
        col_widths = [page_w * 0.28, page_w * 0.72]
    row_h = 6
    pdf.set_font("Helvetica", "", 7)
    for ri, row in enumerate(rows):
        reset_x(pdf)
        if ri == 0:
            pdf.set_fill_color(34, 139, 87)
            pdf.set_text_color(255, 255, 255)
            pdf.set_font("Helvetica", "B", 7)
        else:
            pdf.set_fill_color(245, 248, 246)
            pdf.set_text_color(30, 30, 30)
            pdf.set_font("Helvetica", "", 7)
        start_y = pdf.get_y()
        max_y = start_y
        for ci in range(col_count):
            cell = safe_text(row[ci] if ci < len(row) else "")
            cw = col_widths[ci]
            pdf.set_xy(pdf.l_margin + sum(col_widths[:ci]), start_y)
            pdf.multi_cell(cw, row_h, cell, border=1, fill=True, max_line_height=row_h)
            max_y = max(max_y, pdf.get_y())
        pdf.set_y(max_y)
    reset_x(pdf)


def safe_text(text: str) -> str:
    """Replace Unicode chars unsupported by core Helvetica (avoid '?' placeholders)."""
    replacements = {
        "\u2013": "-",
        "\u2014": "-",
        "\u2018": "'",
        "\u2019": "'",
        "\u201c": '"',
        "\u201d": '"',
        "\u2022": "*",
        "\u2192": "->",
        "\u2264": "<=",
        "\u2265": ">=",
        # Directory tree (box-drawing) -> ASCII
        "\u251c\u2500\u2500": "|--",
        "\u2514\u2500\u2500": "`--",
        "\u2502   ": "|   ",
        "\u2502": "|",
        "\u2500": "-",
    }
    for k, v in replacements.items():
        text = text.replace(k, v)
    # Fallback: any remaining non-latin-1 -> strip or ASCII substitute
    out = []
    for ch in text:
        try:
            ch.encode("latin-1")
            out.append(ch)
        except UnicodeEncodeError:
            if ch in "├└│─":
                out.append("|")
            else:
                out.append(" ")
    return "".join(out)


def build_cover(pdf: ReportPDF, title: str, subtitle: str, meta_lines: list[str]) -> None:
    pdf.add_page()
    w = pdf.epw
    pdf.set_font("Helvetica", "B", 26)
    pdf.set_text_color(22, 101, 52)
    pdf.ln(45)
    pdf.multi_cell(w, 14, safe_text(title), align="C")
    pdf.ln(6)
    pdf.set_font("Helvetica", "", 14)
    pdf.set_text_color(60, 60, 60)
    pdf.multi_cell(w, 8, safe_text(subtitle), align="C")
    pdf.ln(20)
    pdf.set_font("Helvetica", "", 11)
    for line in meta_lines:
        if not line.strip():
            continue
        pdf.multi_cell(w, 7, safe_text(line), align="C")
    pdf.ln(30)
    pdf.set_font("Helvetica", "I", 10)
    pdf.set_text_color(100, 100, 100)
    pdf.multi_cell(
        w, 6, "University Project Report | Academic Year 2025-2026", align="C"
    )


def build_pdf(blocks: list[tuple[str, str]]) -> None:
    pdf = ReportPDF()
    pdf.set_auto_page_break(auto=True, margin=18)
    pdf.set_margins(20, 20, 20)

    titles = [c for k, c in blocks if k == "title"]
    main_title = titles[0] if titles else "Cholo BD"
    sub_title = titles[1] if len(titles) > 1 else "Smart Travel BD"
    meta = []
    for k, c in blocks:
        if k == "body" and c.startswith("**Project Type:**"):
            meta.append(c.replace("**", ""))
        if k == "body" and c.startswith("**Platform:**"):
            meta.append(c.replace("**", ""))
        if k == "body" and c.startswith("**Technology"):
            meta.append(c.replace("**", ""))
        if len(meta) >= 4:
            break
    build_cover(pdf, main_title, sub_title, meta or [
        "Project Type: University Final Year Project",
        "Platform: Android and iOS (Flutter)",
        "Technology: Flutter, Appwrite, Gemini AI, Google Routes",
        "Version: 1.0.0",
    ])

    skip_until_h1 = True
    for kind, content in blocks:
        if kind == "hr":
            continue
        if kind == "title":
            continue
        if skip_until_h1:
            if kind == "h1" and "abstract" in content.lower():
                skip_until_h1 = False
                pdf.add_page()
            else:
                continue

        if kind in ("h1", "h2") and pdf.get_y() > 250:
            pdf.add_page()

        w = pdf.epw
        content = safe_text(content)
        reset_x(pdf)
        if kind == "h1":
            if content.lower().startswith("table of contents"):
                pdf.add_page()
                reset_x(pdf)
            pdf.ln(4)
            pdf.set_font("Helvetica", "B", 14)
            pdf.set_text_color(22, 101, 52)
            pdf.multi_cell(w, 8, content)
            pdf.ln(2)
            reset_x(pdf)
        elif kind == "h2":
            pdf.ln(2)
            pdf.set_font("Helvetica", "B", 11)
            pdf.set_text_color(40, 40, 40)
            pdf.multi_cell(w, 7, content)
            pdf.ln(1)
            reset_x(pdf)
        elif kind == "table":
            pdf.ln(2)
            render_table(pdf, safe_text(content))
            pdf.ln(3)
            reset_x(pdf)
        elif kind == "bullet":
            pdf.set_font("Helvetica", "", 10)
            pdf.set_text_color(50, 50, 50)
            for item in content.split("\n"):
                reset_x(pdf)
                pdf.multi_cell(w, 5, f"  - {safe_text(item)}")
            pdf.ln(2)
            reset_x(pdf)
        elif kind == "code":
            pdf.set_font("Courier", "", 7)
            pdf.set_fill_color(240, 240, 240)
            pdf.set_text_color(30, 30, 30)
            for line in content.split("\n"):
                reset_x(pdf)
                pdf.multi_cell(w, 4.5, safe_text(line), fill=True)
            pdf.ln(2)
            reset_x(pdf)
        elif kind == "body":
            if content.startswith("**Project Type:**") or "University" in content[:80]:
                pdf.set_font("Helvetica", "", 11)
                pdf.set_text_color(60, 60, 60)
            else:
                pdf.set_font("Helvetica", "", 10)
                pdf.set_text_color(50, 50, 50)
            # Break very long words so multi_cell can wrap inside margins
            wrapped = re.sub(r"(\S{60})(\S)", r"\1 \2", content)
            pdf.multi_cell(w, 5, wrapped)
            pdf.ln(1)
            reset_x(pdf)

    # Cover subtitle after first title block handled — add metadata page elements
    pdf.output(str(PDF_PATH))


def main() -> None:
    if not MD_PATH.exists():
        print(f"Missing {MD_PATH}")
        sys.exit(1)
    blocks = parse_markdown(MD_PATH)
    build_pdf(blocks)
    print(f"Generated: {PDF_PATH}")
    print(f"Size: {PDF_PATH.stat().st_size / 1024:.1f} KB")


if __name__ == "__main__":
    main()
