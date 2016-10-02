#!/bin/bash

convert -brightness-contrast 95x50 star.png star-light.png

convert -geometry x16 star.png star.png star.png star.png star.png +append -append ../img/stars-5.png
convert -geometry x16 star.png star.png star.png star.png star-light.png +append -append ../img/stars-4.png
convert -geometry x16 star.png star.png star.png star-light.png star-light.png +append -append ../img/stars-3.png
convert -geometry x16 star.png star.png star-light.png star-light.png star-light.png +append -append ../img/stars-2.png
convert -geometry x16 star.png star-light.png star-light.png star-light.png star-light.png +append -append ../img/stars-1.png


