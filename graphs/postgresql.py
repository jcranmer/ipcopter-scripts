add_gnuplot_commands("""
set grid

set xlabel "Scale Factor"
set ylabel "TPS"

set style data histogram
set boxwidth 0.4
set style fill solid 0.5 border
set yrange [0:25000]
set xtics 0,20
""")

ipcd = read_csv("postgresql.ipcd.csv", xcol=0)[2].mean()
ipcd.title = "Slipstream"
baseline = read_csv("postgresql.baseline.csv", xcol=0)[2].mean()
baseline.title = "Baseline"

plot([ipcd, baseline])
