import os
import subprocess
import markdown

md_path = os.path.join(os.path.dirname(__file__), "PROJECT_REPORT.md")
html_path = os.path.join(os.path.dirname(__file__), "report_styled.html")
pdf_path = os.path.join(os.path.dirname(__file__), "PROJECT_REPORT.pdf")

with open(md_path, "r", encoding="utf-8") as f:
    text = f.read()

# Convert markdown to html with extra extensions (tables, fences)
html_content = markdown.markdown(text, extensions=["tables", "fenced_code"])

styled_html = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Eco Habit Tracker - Academic Project Report</title>
<style>
  @page {{
    size: A4;
    margin: 20mm 15mm 20mm 15mm;
    @bottom-center {{
      content: counter(page);
    }}
  }}
  body {{
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    line-height: 1.6;
    color: #1e293b;
    font-size: 11pt;
    margin: 0;
    padding: 0;
  }}
  h1 {{
    font-size: 20pt;
    color: #0f172a;
    border-bottom: 2px solid #16a34a;
    padding-bottom: 6px;
    margin-top: 24pt;
    text-align: center;
  }}
  h2 {{
    font-size: 15pt;
    color: #166534;
    border-bottom: 1px solid #cbd5e1;
    padding-bottom: 4px;
    margin-top: 20pt;
    page-break-after: avoid;
  }}
  h3 {{
    font-size: 12.5pt;
    color: #1e293b;
    margin-top: 14pt;
    page-break-after: avoid;
  }}
  p, li {{
    text-align: justify;
    text-justify: inter-word;
  }}
  code {{
    background-color: #f1f5f9;
    padding: 2px 5px;
    border-radius: 4px;
    font-family: Consolas, 'Courier New', monospace;
    font-size: 9.5pt;
    color: #0f766e;
  }}
  pre {{
    background-color: #f8fafc;
    border: 1px solid #e2e8f0;
    border-left: 4px solid #16a34a;
    padding: 10px 14px;
    border-radius: 6px;
    font-family: Consolas, 'Courier New', monospace;
    font-size: 9pt;
    overflow-x: auto;
    page-break-inside: avoid;
  }}
  table {{
    width: 100%;
    border-collapse: collapse;
    margin: 16pt 0;
    font-size: 10pt;
    page-break-inside: avoid;
  }}
  th, td {{
    border: 1px solid #cbd5e1;
    padding: 8px 10px;
    text-align: left;
  }}
  th {{
    background-color: #f0fdf4;
    color: #166534;
    font-weight: 700;
  }}
  tr:nth-child(even) {{
    background-color: #f8fafc;
  }}
  hr {{
    border: none;
    height: 1px;
    background-color: #cbd5e1;
    margin: 24pt 0;
  }}
  blockquote {{
    border-left: 4px solid #22c55e;
    margin: 14pt 0;
    padding: 6pt 16pt;
    background-color: #f0fdf4;
    color: #14532d;
    font-style: italic;
  }}
  @media print {{
    h2 {{
      page-break-before: always;
    }}
    .no-break {{
      page-break-inside: avoid;
    }}
  }}
</style>
</head>
<body>
{html_content}
</body>
</html>
"""

with open(html_path, "w", encoding="utf-8") as f:
    f.write(styled_html)

chrome_path = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
cmd = [
    chrome_path,
    "--headless",
    "--disable-gpu",
    f"--print-to-pdf={pdf_path}",
    "--no-pdf-header-footer",
    html_path
]

print("Generating PDF via headless Chrome...")
subprocess.run(cmd, check=True)
print(f"PDF successfully generated at: {pdf_path}")
