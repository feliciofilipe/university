#!/usr/bin/env python3

import time
import os
import statistics
from tabulate import tabulate

print("---- EXECUTION TIMES SCRIPT ----")

rapido = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/rapido.mp3 rapido"

header = ['N', 'μ', 'σ','σ2', 'min', 'max']

x = range(1,181)
y = []

results5 = []

for i in range(0, 5):
    start_time5 = time.time()
    os.system(rapido)
    end_time5 = time.time()
    execution_time_5 = end_time5 - start_time5
    results5.append(execution_time_5)
    y.append(execution_time_5)


line5 =[]
line5.append('5')
line5.append(statistics. mean(results5))
line5.append(statistics.pstdev(results5))
line5.append(statistics.pvariance(results5))
line5.append(min(results5))
line5.append(max(results5))

results10 = []

for i in range(0, 10):
    start_time10 = time.time()
    os.system(rapido)
    end_time10 = time.time()
    execution_time_10 = end_time10 - start_time10
    results10.append(execution_time_10)
    y.append(execution_time_10)


line10 =[]
line10.append('10')
line10.append(statistics. mean(results10))
line10.append(statistics.pstdev(results10))
line10.append(statistics.pvariance(results10))
line10.append(min(results10))
line10.append(max(results10))


results20 = []

for i in range(0, 20):
    start_time20 = time.time()
    os.system(rapido)
    end_time20 = time.time()
    execution_time_20 = end_time20 - start_time20
    results20.append(execution_time_20)
    y.append(execution_time_20)

line20 =[]
line20.append('20')
line20.append(statistics. mean(results20))
line20.append(statistics.pstdev(results20))
line20.append(statistics.pvariance(results20))
line20.append(min(results20))
line20.append(max(results20))

results50 = []

for i in range(0, 50):
    start_time50 = time.time()
    os.system(rapido)
    end_time50 = time.time()
    execution_time_50 = end_time50 - start_time50
    results20.append(execution_time_50)
    y.append(execution_time_50)

line50 =[]
line50.append('50')
line50.append(statistics. mean(results50))
line50.append(statistics.pstdev(results50))
line50.append(statistics.pvariance(results50))
line50.append(min(results50))
line50.append(max(results50))

results100 = []

for i in range(0, 100):
    start_time100 = time.time()
    os.system(rapido)
    end_time100 = time.time()
    execution_time_100 = end_time100 - start_time100
    results100.append(execution_time_100)
    y.append(execution_time_100)

line100 =[]
line100.append('100')
line100.append(statistics. mean(results100))
line100.append(statistics.pstdev(results100))
line100.append(statistics.pvariance(results100))
line100.append(min(results100))
line100.append(max(results100))


# plotting the points
plt.plot(x, y)

# naming the x axis
plt.xlabel('transform request number')
# naming the y axis
plt.ylabel('execution time')

# giving a title to my graph
plt.title('Execution time over 185 requests')

plot_path = 'docs/execution_time_185_requests_plot.png'
print("saving the plot in %s" % plot_path)
plt.savefig(plot_path)

table_path = 'docs/execution_time_185_requests_table.png'
print("saving the table in %s" % table_path)
table = [header,line5,line10,line20,line50,line100]
f = open('data_new.txt', 'wb')
f.writelines(tabulate(table, headers='firstrow'))

answer = "null"
while not answer in ["", "Y", "n", "y"]:
    answer = input("do you wish to see the plot? [Y/n]")

    if (answer in ["", "Y", "y"]):
        plt.show()

answer = "null"
while not answer in ["", "Y", "n", "y"]:
    answer = input("do you wish to see the table? [Y/n]")

    if (answer in ["", "Y", "y"]):
        print(tabulate(table, headers='firstrow'))

answer = "null"
while not answer in ["", "Y", "n", "y"]:
    answer = input("[2/2] do you wish to listen to the result audio? [Y/n]")

    if (answer in ["", "Y", "y"]):
        os.system("cvlc tmp/rapido.mp3")
