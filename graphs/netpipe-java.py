add_gnuplot_commands("""
set logscale x 2
set logscale y 2
set format x "%.0b%BB"
set xtics 1,16
set xrange [2**4:2**24]
set yrange [2**2:2**16]
set xlabel "Transmit size"
set ylabel "Throughput (Mbps)"
set grid noxtics ytics
set key center right
""")

java = read_csv("netpipe-java.ipcd.csv", xcol=4)[2].mean()
java_baseline = read_csv("netpipe-java.baseline.csv", xcol=4)[2].mean()

java.title = "Slipstream"
java_baseline.title = "Baseline"
plot([java, java_baseline])
