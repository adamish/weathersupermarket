
ls -1 *.svg  | perl -pe 's/(.*).svg/\1/' | 
xargs -I{} convert  \
-geometry x16 \
-bordercolor none \
-border 2x2 \
-background none \
{}.svg ../../img/symbol/{}.png
