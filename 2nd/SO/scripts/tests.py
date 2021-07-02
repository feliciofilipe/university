#!/usr/bin/env python3

import time
import os
import filecmp

print("---- TEST SCRIPT ----")

rapido = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/rapido.mp3 rapido"
lento = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/lento.mp3 lento"
eco = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/eco.mp3 eco"
baixo = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/baixo.mp3 baixo"
alto = "bin/aurras transform samples/Ievan\ Polkka\ \(Loituma\).m4a tmp/alto.mp3 alto"

rapido_expected = "bin/aurrasd-filters/aurrasd-tempo-double < samples/Ievan\ Polkka\ \(Loituma\).m4a> tmp/rapido_expected.mp3"
lento_expected = "bin/aurrasd-filters/aurrasd-tempo-half < samples/Ievan\ Polkka\ \(Loituma\).m4a> tmp/lento_expected.mp3"
eco_expected = "bin/aurrasd-filters/aurrasd-echo < samples/Ievan\ Polkka\ \(Loituma\).m4a> tmp/eco_expected.mp3"
baixo_expected = "bin/aurrasd-filters/aurrasd-gain-half < samples/Ievan\ Polkka\ \(Loituma\).m4a> tmp/baixo_expected.mp3"
alto_expected = "bin/aurrasd-filters/aurrasd-gain-double < samples/Ievan\ Polkka\ \(Loituma\).m4a> tmp/alto_expected.mp3"

total_tests = 5
passed_tests = 0

print("[1/%d] testing %s" % (total_tests + 1, rapido))
start_time1 = time.time()
os.system(rapido)
end_time1 = time.time()
execution_time_1 = end_time1 - start_time1
print("execution time: %s" % execution_time_1)
os.system(rapido_expected)
if (filecmp.cmp("tmp/rapido.mp3", "tmp/rapido_expected.mp3", shallow=True)):
    passed_tests += 1

print("[2/%d] testing %s" % (total_tests + 1, lento))
start_time2 = time.time()
os.system(lento)
end_time2 = time.time()
execution_time_2 = end_time2 - start_time2
print("execution time: %s" % execution_time_2)
os.system(lento_expected)
if (filecmp.cmp("tmp/lento.mp3", "tmp/lento_expected.mp3", shallow=True)):
    passed_tests += 1

print("[3/%d] testing %s" % (total_tests + 1, eco))
start_time3 = time.time()
os.system(eco)
end_time3 = time.time()
execution_time_3 = end_time3 - start_time3
print("execution time: %s" % execution_time_3)
os.system(eco_expected)
if (filecmp.cmp("tmp/eco.mp3", "tmp/eco_expected.mp3", shallow=True)):
    passed_tests += 1

print("[4/%d] testing %s" % (total_tests + 1, baixo))
start_time4 = time.time()
os.system(baixo)
end_time4 = time.time()
execution_time_4 = end_time4 - start_time4
print("execution time: %s" % execution_time_4)
os.system(baixo_expected)
if (filecmp.cmp("tmp/baixo.mp3", "tmp/baixo_expected.mp3", shallow=True)):
    passed_tests += 1

print("[5/%d] testing %s" % (total_tests + 1, alto))
start_time5 = time.time()
os.system(alto)
end_time5 = time.time()
execution_time_5 = end_time5 - start_time5
end_time5 = time.time()
print("execution time: %s" % execution_time_5)
os.system(alto_expected)
if (filecmp.cmp("tmp/alto.mp3", "tmp/alto_expected.mp3", shallow=True)):
    passed_tests += 1

print("[%d/%d] %d/%d test passed" %
      (total_tests + 1, total_tests + 1, passed_tests, total_tests))
