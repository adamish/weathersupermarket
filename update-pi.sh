#!/bin/bash

rsync -rv --delete --exclude test --exclude "tmp/http/*" --exclude 'spec' . pi@10.5.1.52:/home/pi/wsm --exclude test 

