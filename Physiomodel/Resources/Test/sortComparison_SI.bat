sort-7.6 -n ../../io/comparison_SI.txt > d.csv
gawk -f removeDuplicates.awk d.csv > %1.csv
rm ../../io/comparison.txt d.csv

