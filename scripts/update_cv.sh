#!/bin/bash
CV_SOURCE="/mnt/hdd/Dropbox/documents/CV_Resume/texCV_20250222"
WEBSITE="$HOME/repos/website"
mkdir -p $WEBSITE/assets/cv

cd $CV_SOURCE
pdftohtml -noframes -s JacobPeters.pdf /tmp/cv_raw.html

python3 << 'PYEOF'
from pathlib import Path

html = Path('/tmp/cv_raw.html').read_text()

# Fix dark background / override styles
html = html.replace(
    '</style>',
    'body { background: white !important; color: black !important; max-width: 900px; margin: 0 auto; padding: 2rem; }\n</style>'
)

# Fix run-together text (pdftohtml often drops spaces between spans)
import re
html = re.sub(r'</span><span', '</span> <span', html)

Path('/tmp/cv_clean.html').write_text(html)
PYEOF

cp /tmp/cv_clean.html $WEBSITE/assets/cv/cv.html
cp JacobPeters.pdf $WEBSITE/assets/cv/JacobPeters.pdf

echo "Done. Check assets/cv/cv.html then commit."