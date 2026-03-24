#!/bin/bash
CV_SOURCE="/mnt/hdd/Dropbox/documents/CV_Resume/texCV_20250222"
WEBSITE="$HOME/repos/website"

mkdir -p $WEBSITE/assets/cv
cd $CV_SOURCE

pandoc JacobPeters.tex -f latex -t markdown -o cv_temp.md

sed -i 's/::://g' cv_temp.md
sed -i 's/etaremune//g' cv_temp.md
sed -i 's/\\$/  /' cv_temp.md

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
cp JacobPeters.pdf $WEBSITE/assets/cv/
rm cv_temp.md

echo "CV files updated. Review _pages/cv.md and commit when ready:"
echo "  cd $WEBSITE"
echo "  git add _pages/cv.md assets/cv/JacobPeters.pdf"
echo "  git commit -m 'Update CV'"
echo "  git push"