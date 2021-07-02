#!/usr/bin/env python3

import matplotlib.pyplot as plt
import time
import os

print("---- INCREASING FILTERS SCRIPT ----")

print("[1/13] checking that the folder tmp/ exits")

if not os.path.isdir("tmp"):
    os.makedirs(MYDIR)
    print("[2/13] creating folder tmp/")
else:
    print("[2/13] folder tmp exits")

request1 = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/output1.mp4 rapido"
request2 = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/output2.mp4 rapido rapido"
request3 = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/output3.mp4 rapido rapido rapido"
request4 = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/output4.mp4 rapido rapido rapido rapido"
request5 = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/output5.mp4 rapido rapido rapido rapido rapido"
request6 = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/output6.mp4 rapido rapido rapido rapido rapido rapido"
request7 = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/output7.mp4 rapido rapido rapido rapido rapido rapido rapido"
request8 = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/output8.mp4 rapido rapido rapido rapido rapido rapido rapido rapido"
request9 = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/output9.mp4 rapido rapido rapido rapido rapido rapido rapido rapido rapido"
request10 = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/output10.mp4 rapido rapido rapido rapido rapido rapido rapido rapido rapido rapido"

print("[3/13] %s" % request1)
start_time_1 = time.time()
os.system(request1)
end_time_1 = time.time()
execution_time_1 = end_time_1 - start_time_1

print("[4/13] %s" % request2)
start_time_2 = time.time()
os.system(request2)
end_time_2 = time.time()
execution_time_2 = end_time_2 - start_time_2

print("[5/13] %s" % request3)
start_time_3 = time.time()
os.system(request3)
end_time_3 = time.time()
execution_time_3 = end_time_3 - start_time_3

print("[6/13] %s" % request4)
start_time_4 = time.time()
os.system(request4)
end_time_4 = time.time()
execution_time_4 = end_time_4 - start_time_4

print("[7/13] %s" % request5)
start_time_5 = time.time()
os.system(request5)
end_time_5 = time.time()
execution_time_5 = end_time_5 - start_time_5

print("[8/13] %s" % request6)
start_time_6 = time.time()
os.system(request6)
end_time_6 = time.time()
execution_time_6 = end_time_6 - start_time_6

print("[9/13] %s" % request7)
start_time_7 = time.time()
os.system(request7)
end_time_7 = time.time()
execution_time_7 = end_time_7 - start_time_7

print("[10/13] %s" % request8)
start_time_8 = time.time()
os.system(request8)
end_time_8 = time.time()
execution_time_8 = end_time_8 - start_time_8

print("[11/13] %s" % request9)
start_time_9 = time.time()
os.system(request9)
end_time_9 = time.time()
execution_time_9 = end_time_9 - start_time_9

print("[12/13] %s" % request10)
start_time_10 = time.time()
os.system(request10)
end_time_10 = time.time()
execution_time_10 = end_time_10 - start_time_10

# x axis values
x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# corresponding y axis values
y = [
    execution_time_1,
    execution_time_2,
    execution_time_3,
    execution_time_4,
    execution_time_5,
    execution_time_6,
    execution_time_7,
    execution_time_8,
    execution_time_9,
    execution_time_10,
]

# plotting the points
plt.plot(x, y)

# naming the x axis
plt.xlabel('number of filters')
# naming the y axis
plt.ylabel('execution time')

# giving a title to my graph
plt.title('Performance by increasing number of filters')

plot_path = 'docs/increasing_by_filters.png'
print("[13/13] saving the plot in %s" % plot_path)
plt.savefig(plot_path)

answer = "null"
while not answer in ["", "Y", "n", "y"]:
    answer = input("do you wish to see the plot? [Y/n]")

    if (answer in ["", "Y", "y"]):
        plt.show()
