add_gnuplot_commands("""
set logscale x 2
set format x "%.0b%BB"
set xtics 1,4
set xrange [1:2**20]
set yrange [0:3]
set grid
set xlabel "Transmit size"
set ylabel "Throughput ratio"
set key top left
set pointsize 0.6
""")

ipcd = read_csv("netperf.ipcd.csv", xcol=2)[4]
ipcd.baseline(read_csv("netperf.baseline.csv", xcol=2)[4])
ipcd.title = "Slipstream"
uds = read_csv("netperf.uds.csv", xcol=2)[4]
uds.baseline(read_csv("netperf.baseline.csv", xcol=2)[4])
uds.title = "UDS"
fixed = read_csv("netperf.uds-fixed.csv", xcol=2)[4]
fixed.baseline(read_csv("netperf.baseline.csv", xcol=2)[4])
fixed.title = "UDS-modified"
tcp = read_csv("netperf.tcp-nodelay.csv", xcol=2)[4]
tcp.baseline(read_csv("netperf.baseline.csv", xcol=2)[4])
tcp.title = "TCP_NODELAY"
unopt = read_csv("netperf.unopt.csv", xcol=2)[4]
unopt.baseline(read_csv("netperf.baseline.csv", xcol=2)[4])
unopt.title = "Slipstream (unopt)"
plot([ipcd, fixed, uds, tcp, unopt])
