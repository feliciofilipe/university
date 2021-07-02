#!/usr/bin/env python3

import time
import os

print("---- SIMPLE REQUEST SCRIPT ----")

request1 = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/double_rapido.mp4 rapido rapido"

print("[1/2] %s" % request1)

start_time = time.time()
os.system(request1)
end_time = time.time()

print("execution time: %s" % (end_time - start_time))

answer = "null"
while not answer in ["", "Y", "n", "y"]:
    answer = input("[2/2] do you wish to listen to the result audio? [Y/n]")

    if (answer in ["", "Y", "y"]):
        os.system("cvlc tmp/double_rapido.mp4")
