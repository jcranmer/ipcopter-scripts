add_gnuplot_commands("""
set grid
set xlabel "Requesting threads"
set ylabel "Ops/Sec"
set yrange [0:300000]
set xrange [0:16]
""")

threads = lambda row : row[1] == 50

ipcd = read_csv("memcache.ipcd.csv", xcol=0).select(threads)[5]
ipcd.title = "Slipstream"
baseline = read_csv("memcache.baseline.csv", xcol=0).select(threads)[5]
baseline.title = "Baseline"
unopt = read_csv("memcache.unopt.csv", xcol=0).select(threads)[5]
unopt.title = "Slipstream (unopt)"
plot([ipcd, baseline, unopt])
