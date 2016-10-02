#!/bin/bash

ls -1 *.png | cut -d. -f1 | xargs -I{} convert \
-geometry x13 \
-extent 82x21 \
-background 'transparent' \
-bordercolor none \
-gravity west +repage {}.* ../../img/provider/{}.png
