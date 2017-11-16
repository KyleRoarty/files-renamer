#!/bin/bash

show_help() {
    echo "Usage: ToDo"
}

valid_arg() {
    if [ -z "$1" ]; then
        show_help
        exit 1
    else
        echo "Valid variable"
    fi
}


#array=${@:1:$(($#-1))}
#len=${#array[@]}

OPTIND=1

indArr=()
last=""
indStr=""
len=0

while getopts "i:" opt; do
    case "$opt" in
    i)
        indStr=$OPTARG
        indArr=(${indStr//,/ })
        last=${indArr[-1]}

        unset 'indArr[${#arr[@]}-1]'
        len=${#indArr[@]}
        ;;
    esac
done

echo $indArr
valid_arg $indStr

for f in *.*
do
    mv -- "$f"\
          "$(awk -v var="${indArr[*]}" -v l="$len" -v num="$last" -F '[ .]'\
             'BEGIN {split(var, varArr, / /)}
              { for(x in varArr) printf "%s ",$varArr[x] }
              { if(l != 0) {printf "- "} }
              { printf "%s.%s",$num,$NF }' <<< "$f")"
done
