#!/usr/bin/env python3
"""Generate TEAM_REPORT.docx — ১৬টি UI অংশ, Person 1–16 ফরম্যাট (কোড সহ)।"""

from __future__ import annotations

from pathlib import Path

from docx import Document
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml.ns import qn
from docx.shared import Inches, Pt, RGBColor

ROOT = Path(__file__).resolve().parent.parent
DOCS = Path(__file__).resolve().parent
LIB = ROOT / "lib"
OUT = DOCS / "TEAM_REPORT.docx"

BODY_FONT = "Calibri"
CODE_FONT = "Consolas"

MEMBERS = [
    ("Member 1", "Part 1", "Splash + Onboarding 1"),
    ("Member 2", "Part 2", "Onboarding ২"),
    ("Member 3", "Part 3", "Onboarding ৩"),
    ("Member 4", "Part 4", "নাম পেজ"),
    ("Member 5", "Part 5", "পছন্দের জায়গা"),
    ("Member 6", "Part 6", "Login"),
    ("Member 7", "Part 7", "Homepage"),
    ("Member 8", "Part 8", "Profile"),
    ("Member 9", "Part 9", "All Districts"),
    ("Member 10", "Part 10", "District Places"),
    ("Member 11", "Part 11", "Place Details"),
    ("Member 12", "Part 12", "My Trips"),
    ("Member 13", "Part 13", "Plan Trip — District"),
    ("Member 14", "Part 14", "Plan Trip — Places"),
    ("Member 15", "Part 15", "Date, Time, Start Location"),
    ("Member 16", "Part 16", "Transport + Confirm"),
]

PARTS: list[dict] = [
    {
        "person": 1,
        "title": "Splash Screen + Onboarding 1",
        "sections": [
            ("Splash Screen", [
                "lib/feature/splash_screen/splash_screen.dart",
                "lib/feature/splash_screen/splash_screen_controller.dart",
            ]),
            ("Onboarding 1", [
                "lib/feature/onboarding/pages/onboarding_step1_page.dart",
            ]),
        ],
    },
    {
        "person": 2,
        "title": "Onboarding 2",
        "sections": [
            ("Onboarding 2", [
                "lib/feature/onboarding/pages/onboarding_step2_page.dart",
            ]),
        ],
    },
    {
        "person": 3,
        "title": "Onboarding 3",
        "sections": [
            ("Onboarding 3", [
                "lib/feature/onboarding/pages/onboarding_step3_page.dart",
            ]),
        ],
    },
    {
        "person": 4,
        "title": "নাম পেজ (Name Page)",
        "sections": [
            ("Name Page", [
                "lib/feature/onboarding/pages/onboarding_step4_name_page.dart",
            ]),
        ],
    },
    {
        "person": 5,
        "title": "পছন্দের জায়গা (Preference)",
        "sections": [
            ("Favourite Place Select", [
                "lib/feature/onboarding/pages/onboarding_step5_preference_page.dart",
            ]),
        ],
    },
    {
        "person": 6,
        "title": "Login Page",
        "sections": [
            ("Login UI", ["lib/feature/auth/auth_page.dart"]),
            ("Login Controller", ["lib/feature/auth/auth_controller.dart"]),
        ],
    },
    {
        "person": 7,
        "title": "Homepage",
        "sections": [
            ("Home Page", ["lib/feature/homepage/presentation/home_page.dart"]),
            ("Home Controller", [
                "lib/feature/homepage/presentation/home_page_controller.dart"
            ]),
        ],
    },
    {
        "person": 8,
        "title": "Profile Page",
        "sections": [
            ("Profile Page", ["lib/feature/profile/profile_page.dart"]),
        ],
    },
    {
        "person": 9,
        "title": "All Districts",
        "sections": [
            ("All Districts Page", ["lib/feature/all_districts/all_districts_page.dart"]),
        ],
    },
    {
        "person": 10,
        "title": "District Places",
        "sections": [
            ("District Places Page", [
                "lib/feature/district_places/district_places_page.dart"
            ]),
            ("District Places Controller", [
                "lib/feature/district_places/district_places_controller.dart"
            ]),
        ],
    },
    {
        "person": 11,
        "title": "Place Details",
        "sections": [
            ("Place Details Page", [
                "lib/feature/place_details/place_details_page.dart"
            ]),
            ("Place Details Controller", [
                "lib/feature/place_details/place_details_controller.dart"
            ]),
        ],
    },
    {
        "person": 12,
        "title": "My Trips",
        "sections": [
            ("Trips Page", ["lib/feature/trips/trips_page.dart"]),
            ("Trips Controller", ["lib/feature/trips/trips_controller.dart"]),
        ],
    },
    {
        "person": 13,
        "title": "Plan Trip — District Select",
        "sections": [
            ("Step District", [
                "lib/feature/trip_planning/presentation/widgets/step_district.dart"
            ]),
        ],
    },
    {
        "person": 14,
        "title": "Plan Trip — Select Places",
        "sections": [
            ("Step Places", [
                "lib/feature/trip_planning/presentation/widgets/step_places.dart"
            ]),
        ],
    },
    {
        "person": 15,
        "title": "Date, Time, Start Location",
        "sections": [
            ("Step DateTime", [
                "lib/feature/trip_planning/presentation/widgets/step_datetime.dart"
            ]),
        ],
    },
    {
        "person": 16,
        "title": "Transport + Confirm",
        "sections": [
            ("Step Transport", [
                "lib/feature/trip_planning/presentation/widgets/step_transport.dart"
            ]),
            ("Step Confirm", [
                "lib/feature/trip_planning/presentation/widgets/step_confirm.dart"
            ]),
        ],
    },
]


def set_run_font(run, name: str, size_pt: int | None = None, bold: bool = False) -> None:
    run.font.name = name
    run.bold = bold
    if size_pt:
        run.font.size = Pt(size_pt)
    r_pr = run._element.get_or_add_rPr()
    r_fonts = r_pr.get_or_add_rFonts()
    for attr in ("w:ascii", "w:hAnsi", "w:cs", "w:eastAsia"):
        r_fonts.set(qn(attr), name)


def add_centered(doc: Document, text: str, size: int = 11, bold: bool = False, color=None) -> None:
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = p.add_run(text)
    set_run_font(run, BODY_FONT, size, bold=bold)
    if color:
        run.font.color.rgb = color


def add_body(doc: Document, text: str, bold: bool = False) -> None:
    p = doc.add_paragraph()
    run = p.add_run(text)
    set_run_font(run, BODY_FONT, 11, bold=bold)


def add_bullet(doc: Document, text: str) -> None:
    p = doc.add_paragraph(style="List Bullet")
    run = p.add_run(text)
    set_run_font(run, BODY_FONT, 11)


def add_code_block(doc: Document, code: str) -> None:
    for line in code.splitlines():
        p = doc.add_paragraph()
        run = p.add_run(line)
        set_run_font(run, CODE_FONT, 8)
        p.paragraph_format.space_after = Pt(0)
        p.paragraph_format.space_before = Pt(0)
        p.paragraph_format.line_spacing = 1.0


def read_dart(rel_path: str) -> str:
    path = ROOT / rel_path
    if not path.exists():
        return f"// ফাইল পাওয়া যায়নি: {rel_path}"
    return path.read_text(encoding="utf-8")


def add_cover(doc: Document) -> None:
    add_centered(
        doc,
        "Cholo BD (Smart Travel BD) — টিম পেজ গাইড",
        size=24,
        bold=True,
        color=RGBColor(22, 101, 52),
    )
    for line in (
        "Smart Travel BD — ১৬টি UI অংশ",
        "১৫ সদস্যের দল | সহজ বাংলা গাইড",
        "University Project — Cholo BD",
    ):
        add_centered(doc, line, size=13)
    doc.add_page_break()


def add_overview(doc: Document) -> None:
    add_body(
        doc,
        "প্রজেক্ট: বাংলাদেশ ভ্রমণ অ্যাপ (Flutter)  |  দল: ১৫ জন সদস্য  |  UI অংশ: ১৬টি  |  ভাষা: সহজ বাংলা",
    )
    doc.add_paragraph()

    doc.add_heading("সদস্য বরাদ্দ তালিকা (১৫ জন → ১৬ অংশ)", level=1)
    table = doc.add_table(rows=1 + len(MEMBERS), cols=3)
    table.style = "Table Grid"
    headers = ["সদস্য", "অংশ", "পেজ / স্ক্রিন"]
    for i, h in enumerate(headers):
        table.rows[0].cells[i].text = h
        for run in table.rows[0].cells[i].paragraphs[0].runs:
            run.bold = True
    for ri, (member, part, screen) in enumerate(MEMBERS, start=1):
        table.rows[ri].cells[0].text = member
        table.rows[ri].cells[1].text = part
        table.rows[ri].cells[2].text = screen
    doc.add_paragraph()

    doc.add_heading("স্বাক্ষর তালিকা (আপনি পূরণ করুন)", level=1)
    sig = doc.add_table(rows=5, cols=4)
    sig.style = "Table Grid"
    for i, h in enumerate(["সদস্যের নাম", "Student ID", "অংশ", "স্বাক্ষর"]):
        sig.rows[0].cells[i].text = h
    doc.add_paragraph()

    doc.add_heading("অ্যাপ সম্পর্কে সংক্ষেপে (সবাই পড়ুন)", level=1)
    add_body(
        doc,
        "Cholo BD হলো বাংলাদেশের জেলা ও দর্শনীয় স্থান খুঁজে ট্রিপ প্ল্যান করার মোবাইল অ্যাপ।",
    )
    for item in (
        "Flutter = এক কোড দিয়ে Android ও iOS অ্যাপ।",
        "Widget = স্ক্রিনের প্রতিটি অংশ (বাটন, টেক্সট, ছবি)।",
        "Controller = বাটন চাপলে কী হবে, ডেটা লোড — সেটা নিয়ন্ত্রণ করে।",
        "GetX = স্ক্রিন বদলানো (Get.toNamed) ও রিঅ্যাক্টিভ UI (Obx)।",
        "Route = প্রতিটি পেজের ঠিকানা (যেমন /auth, /tabbar)।",
    ):
        add_bullet(doc, item)
    add_body(
        doc,
        "Parts 12–16 একই পেজের ভিতর: TripPlanningPage — উপরে প্রগ্রেস বার, নিচে ধাপ অনুযায়ী UI।",
    )
    doc.add_page_break()


def add_part(doc: Document, part: dict) -> None:
    n = part["person"]
    doc.add_heading(f"Person {n} — {part['title']}", level=1)

    for section_name, files in part["sections"]:
        doc.add_heading(section_name, level=2)
        file_label = ", ".join(files)
        add_body(doc, f"ফাইল: {file_label}", bold=True)
        doc.add_paragraph()
        for rel in files:
            if len(files) > 1:
                add_body(doc, rel, bold=True)
            add_code_block(doc, read_dart(rel))
            doc.add_paragraph()

    doc.add_page_break()


def build() -> None:
    doc = Document()
    section = doc.sections[0]
    section.top_margin = Inches(0.75)
    section.bottom_margin = Inches(0.75)
    section.left_margin = Inches(0.7)
    section.right_margin = Inches(0.7)

    style = doc.styles["Normal"]
    style.font.name = BODY_FONT
    style.font.size = Pt(11)

    add_cover(doc)
    add_overview(doc)
    for part in PARTS:
        add_part(doc, part)

    doc.save(str(OUT))
    print(f"Generated: {OUT}")
    print(f"Size: {OUT.stat().st_size / 1024:.1f} KB")


if __name__ == "__main__":
    build()
