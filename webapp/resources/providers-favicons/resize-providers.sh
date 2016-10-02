#!/bin/bash

ls -1 *.ico | cut -d. -f1 | xargs -I{} convert \
-geometry 16x16 \
-frame 0 \
-background 'transparent' \
-bordercolor none \
-gravity center +repage {}.* ../../img/provider/{}.png
