set terminal png size 1024,768

set size 1,1
set style line 1 lc rgb '#0060ad' lt 1 lw 2 ps 0.5 pt 5
set style line 2 lc rgb 'green' lt 1 lw 2 ps 0.5 pt 7

set output "result3.png"

set key left top

set grid y

set xlabel 'requests'

set ylabel "response time (ms)"

set datafile separator '\t'

plot "result.plot" every ::2 using 5 with linespoints ls 1 title "response time",\
"result2.plot" every ::2 using 5 with linespoints ls 2 title "response time"
exit
