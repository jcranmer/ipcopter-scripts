add_gnuplot_commands("""
set logscale x 2
set format x "%.0b%BB"
set xtics 1,16
set xrange [2**4:2**24]
set yrange [0:3]
set xlabel "Transmit size"
set ylabel "Slipstream throughput ratio"
set grid noxtics ytics
""")

c = read_csv("netpipe.ipcd.csv", xcol=2)[3].mean()
c_baseline = read_csv("netpipe.baseline.csv", xcol=2)[3].mean()
java = read_csv("netpipe-java.ipcd.csv", xcol=4)[2].mean()
java_baseline = read_csv("netpipe-java.baseline.csv", xcol=4)[2].mean()

c.baseline(c_baseline)
c.title = "NetPIPE-C"
java.baseline(java_baseline)
java.title = "NetPIPE-Java"
plot([c, java])
