#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'You need arguments!'
    exit 1
fi


array=${@:1:$(($#-1))}
len=${#array[@]}

for f in *.*
do
    mv "$f"\
       "$(awk -v var="${array[*]}" -v l="$len" -v num="${!#}" -F '[ .]'\
           'BEGIN {split(var, varArr, / /)}
            { for(x in varArr) printf "%s ",$varArr[x] }
            { print "- " $num "." $NF }' <<< "$f")"
done
