add_gnuplot_commands("""
set logscale x 2
set logscale y 10
set format x "%.0b%BB"
set xtics 1,16
set xrange [2**4:2**24]
#set yrange [0:5]
set xlabel "Transmit size"
set ylabel "Slipstream throughput (KB/s)"
set grid noxtics ytics
set key top left
""")

c = read_csv("netpipe.ipcd.csv", xcol=2)[3].mean()
c_baseline = read_csv("netpipe.baseline.csv", xcol=2)[3].mean()

#c.baseline(c_baseline)
c.title = "Slipstream"
#java.baseline(java_baseline)
c_baseline.title = "Baseline"
plot([c, c_baseline])
