#!/bin/bash
CV_SOURCE="/mnt/hdd/Dropbox/documents/CV_Resume/texCV_20250222"
WEBSITE="$HOME/repos/website"
CVMD="$WEBSITE/_pages/cv.md"
mkdir -p $WEBSITE/assets/cv

cd $CV_SOURCE
pandoc JacobPeters.tex -f latex -t markdown -o $CVMD

# Clean up pandoc/LaTeX artifacts
# Delete pandoc fenced-div lines (::: resume, :::: etaremune, closing :::, etc.)
sed -i -E '/^:{3,}/d' $CVMD
# Strip trailing LaTeX line-break backslashes
sed -i 's/\\$//' $CVMD


# Fix line breaks using Python (more reliable than sed for trailing spaces)
python3 << 'PYEOF'
import re, os
path = os.path.expanduser('~/repos/website/_pages/cv.md')
lines = open(path).readlines()
out = []
# Remove website link from contact section (redundant on website)
lines = [l for l in lines if 'jacobdjpeters.github.io' not in l]
for line in lines:
    stripped = line.rstrip('\n')
    # Right-float contact items to mirror two-column LaTeX layout 
    stripped = re.sub(r'\s+(<[^>]*@[^>]*>)$', r' <span class="contact-right">\1</span>', stripped)
    stripped = re.sub(r'\s+(\[1-\d[^\]]*\]\([^)]*\))$', r' <span class="contact-right">\1</span>', stripped)
    if re.match(r'^(Member,|President,|Darden|email:|office phone:)', stripped):
        out.append(stripped + '  \n')
    elif re.match(r'^(360 Prospect|The Forest School|New Haven)', stripped):
        out.append(stripped + '  \n')
    else:
        out.append(line)
open(path, 'w').writelines(out)
PYEOF

# Prepend front matter and JS/CSS
python3 << 'PYEOF'
import os
path = os.path.expanduser('~/repos/website/_pages/cv.md')
body = open(path).read()
header = """---
layout: archive
title: "CV"
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
---

{% include base_path %}

<style>
  .date-right { float: right; margin-left: 1em; }
  .contact-right { float: right; }
  p, li { overflow: hidden; }
  li p { margin: 0; padding: 0; }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const datePattern = /^((?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|Spring|Fall|Summer|Winter|\\d{4})[^<]*)$/;
  document.querySelectorAll('strong').forEach(el => {
    if (datePattern.test(el.textContent.trim())) {
      el.classList.add('date-right');
    }
  });
});
</script>

[Download PDF](/assets/cv/JacobPeters.pdf){: .btn .btn--info}

"""
open(path, 'w').write(header + body)
PYEOF

cp JacobPeters.pdf $WEBSITE/assets/cv/
echo "Done. Review $CVMD and commit when ready."