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

c = read_csv("netpipe.ipcd.csv", xcol=2)[3].mean()
c_baseline = read_csv("netpipe.baseline.csv", xcol=2)[3].mean()
docker = read_csv("docker_eval/netpipe/netpipe.ipcd.csv", xcol=2)[3].mean()
docker_baseline = read_csv("docker_eval/netpipe/netpipe.baseline.csv", xcol=2)[3].mean()

c.title = "Slipstream"
c_baseline.title = "Baseline"
docker.title = "Slipstream Docker"
docker_baseline.title = "Baseline Docker"
plot([c, docker, c_baseline, docker_baseline])
