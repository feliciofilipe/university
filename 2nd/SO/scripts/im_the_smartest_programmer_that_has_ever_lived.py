#!/usr/bin/env python3

import time
import os

print("---- SPECIAL SCRIPT ----")
print("in memory of Terry A. Davis (1969-2018)")

request1 = "bin/aurras transform samples/The\ smartest\ programmer\ who\ has\ ever\ lived.mp3 tmp/terry.mp4 eco alto"

print("[1/2] %s" % request1)

start_time = time.time()
os.system(request1)
end_time = time.time()

print("execution time: %s" % (end_time - start_time))

answer = "null"
while not answer in ["", "Y", "n", "y"]:
    answer = input("[2/2] do you wish to listen to the result audio? [Y/n]")

    if (answer in ["", "Y", "y"]):
        os.system("cvlc tmp/terry.mp4")
