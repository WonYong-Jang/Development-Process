set terminal png size 1024,768

set size 1,1
set style line 1 lc rgb '#0060ad' lt 1 lw 2 ps 0.7 pt 2
set style line 2 lc rgb 'green' lt 1 lw 2 ps 0.7 pt 5

set output "result5.png"

set key left top font ",18"

set grid y
set xlabel "requests" font ",18"
set ylabel "response time (ms)" font",18"
set tics font ",15"
set datafile separator '\t'

plot "result.plot" using 4 with linespoints ls 1 title "response time(port 8080)",\
"result2.plot" using 4 with linespoints ls 2 title "response time(port     80)"
exit
