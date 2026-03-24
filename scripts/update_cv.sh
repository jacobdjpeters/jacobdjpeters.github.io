#!/bin/bash
CV_SOURCE="/mnt/hdd/Dropbox/documents/CV_Resume/texCV_20250222"
WEBSITE="$HOME/repos/website"
mkdir -p $WEBSITE/assets/cv

cd $CV_SOURCE
pandoc JacobPeters.tex -f latex -t html5 --standalone \
  --metadata title="Jacob D. J. Peters — CV" \
  -o $WEBSITE/assets/cv/cv_raw.html

python3 << 'PYEOF'
import re
from pathlib import Path
import os

website = os.path.expanduser('~/repos/website')
html = Path(f'{website}/assets/cv/cv_raw.html').read_text()

# Case 1: bold date spans (from \hfill {\bf ...} in main CV)
html = re.sub(
    r'<span><strong>((?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|Spring|Fall|Summer|Winter|\d{4})[^<]*)</strong></span>',
    r'<span class="date"><strong>\1</strong></span>',
    html
)

# Case 2: plain text dates at end of <p> inside <li> (from talksContent \hfill{} dates)
html = re.sub(
    r'(\s)((?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{4})(</p>)',
    r' <span class="date">\2</span>\3',
    html
)

# Case 3: bold dates without span wrapper (from \textbf{Month Year} in talks)
html = re.sub(
    r'<strong>((?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{4})</strong>',
    r'<span class="date"><strong>\1</strong></span>',
    html
)

css = """
<style>
  body {
    max-width: 860px;
    margin: 0 auto;
    padding: 2rem 3rem;
    font-family: Georgia, serif;
    font-size: 15px;
    line-height: 1.5;
    color: #111;
    background: white;
  }
  h1 { font-size: 1.4em; margin-bottom: 0.2em; }
  h2 { font-size: 1.1em; border-bottom: 1px solid #ccc; margin-top: 1.5em; }
  p, li { margin: 0.2em 0; }
  br { clear: both; }
  span.date {
    float: right;
    margin-left: 1em;
    font-weight: normal;
    color: #333;
  }
  .references p { margin-bottom: 1em; }
</style>
"""

html = html.replace('</head>', css + '</head>')

Path(f'{website}/assets/cv/cv_raw.html').unlink()
Path(f'{website}/assets/cv/cv.html').write_text(html)
print("CV HTML written.")
PYEOF

cp $CV_SOURCE/JacobPeters.pdf $WEBSITE/assets/cv/JacobPeters.pdf

echo "Done. Review $WEBSITE/assets/cv/cv.html then commit:"
echo "  cd $WEBSITE"
echo "  git add assets/cv/"
echo "  git commit -m 'Update CV'"
echo "  git push"