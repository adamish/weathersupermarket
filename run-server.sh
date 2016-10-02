#!/bin/bash

export RAILS_ENV="production"

killall ruby
sleep 5
nohup thin --port 35881 --threaded --max-conns 30 start &


