add_gnuplot_commands("""
set logscale x 2
set format x "%.0b%BB"
set xtics 1,4
set xrange [1:2**20]
set yrange [0:3]
set grid
set xlabel "Transmit size"
set ylabel "Throughput ratio"
""")

ipcd = read_csv("netperf.ipcd.csv", xcol=2)[4]
ipcd.baseline(read_csv("netperf.baseline.csv", xcol=2)[4])
ipcd.title = "Slipstream"
plot([ipcd])
