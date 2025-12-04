#!/bin/bash

CV_SOURCE="/mnt/hdd/Dropbox/documents/CV_Resume/texCV_20250222"
WEBSITE="/mnt/hdd/Dropbox/website"

# Create assets/cv directory if it doesn't exist
mkdir -p $WEBSITE/assets/cv

cd $CV_SOURCE

# Convert LaTeX to Markdown
pandoc JacobPeters.tex -f latex -t markdown -o cv_temp.md

# Clean up pandoc artifacts
sed -i 's/::://g' cv_temp.md
sed -i 's/etaremune//g' cv_temp.md
sed -i 's/\\$/  /' cv_temp.md

# Create the CV page with front matter
cat > $WEBSITE/_pages/cv.md << 'EOF'
---
layout: archive
title: "CV"
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
---

{% include base_path %}

[Download PDF version](/assets/cv/JacobPeters.pdf){: .btn .btn--info}

EOF

tail -n +2 cv_temp.md >> $WEBSITE/_pages/cv.md

# Copy the PDF
cp JacobPeters.pdf $WEBSITE/assets/cv/

rm cv_temp.md

cd $WEBSITE
git add _pages/cv.md assets/cv/JacobPeters.pdf
git commit -m "Update CV" && git push