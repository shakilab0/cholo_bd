# Project Report (Cholo BD)

## Files

| File | Description |
|------|-------------|
| `PROJECT_REPORT.md` | Full A–Z report (edit this, then regenerate PDF/DOCX) |
| `PROJECT_REPORT.pdf` | Printable PDF for submission |
| `PROJECT_REPORT.docx` | Microsoft Word document (edit in Word / Google Docs) |
| `generate_report_pdf.py` | PDF generator script |
| `generate_report_docx.py` | Word (.docx) generator script |

## Regenerate PDF

```bash
cd docs
python3 -m venv .venv          # first time only
source .venv/bin/activate      # Windows: .venv\Scripts\activate
pip install fpdf2
python generate_report_pdf.py
```

Output: `docs/PROJECT_REPORT.pdf`

## Generate Word document (.docx)

```bash
cd docs
source .venv/bin/activate
pip install python-docx   # first time only
python generate_report_docx.py
```

Output: `docs/PROJECT_REPORT.docx` — open in **Microsoft Word**, **LibreOffice**, or upload to **Google Docs**.

## Before submission

1. Open `PROJECT_REPORT.md` and fill in **Appendix** fields (name, student ID, department, university, supervisor).
2. Regenerate the PDF.
3. Add screenshots of the app as a separate appendix if your teacher requires them.
