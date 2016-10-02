#!/bin/bash

find production/img -name "*.png" | xargs -i{} optipng -o 2 {}

