#!/bin/bash

gradle :production :js

#rsync -rv production/ adamish@adamish.com:alpha.weathersupermarket.co.uk
#rsync -rv production/ adamish@adamish.com:beta.weathersupermarket.co.uk
rsync -rv production/ adamish@adamish.com:weathersupermarket.co.uk

