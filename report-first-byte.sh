#!/bin/bash

while getopts u:n:l:s: flag
do
    case "${flag}" in
        u) uri=${OPTARG};;
        n) requests=${OPTARG};;
        l) label=${OPTARG};;
        s) wsleep=${OPTARG};;
    esac
done

touch "${label}-report.csv"
echo -e "${label}\n" >> ${label}-report.csv
echo -e "Uri: $uri\n" >> ${label}-report.csv
cat report-header-csv.txt >> ${label}-report.csv

x=$requests
while [ $x -gt 0 ];
do
    echo -n `date +%Y-%m-%dT%T` >> ${label}-report.csv
    curl -w "@curl-format-csv.txt" -r 0-1 -o /dev/null -s $uri >> ${label}-report.csv
    sleep $wsleep
    x=$(($x-1))
done
