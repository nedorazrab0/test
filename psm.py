#!/usr/bin/env python3
#
# smooth dim

from time import sleep
from subprocess import call, check_output
from math import ceil

sec = 30

brightnow = int(check_output(["brightnessctl", "g"]))
step = str(ceil(brightnow/sec))

for i in range(sec):
    call(["brightnessctl", "-q", "-n10", "s", step + "-"])
    sleep(1)
  
