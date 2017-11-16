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

# Rename including passed numbers
rename_i(){
    indArr=$1
    last=$2
    len=$3

    for f in *.*
    do
        mv -- "$f"\
              "$(awk -v var="${indArr[*]}" -v l="$len" -v num="$last" -F '[ .]'\
                 'BEGIN {split(var, varArr, / /)}
                  { for(x in varArr) printf "%s ",$varArr[x] }
                  { if(l != 0) {printf "- "} }
                  { printf "%s.%s",$num,$NF }' <<< "$f")"
    done
}

# Rename excluding passed numbers
rename_x(){
    indArr=$1

    for f in *.*
    do
        mv -- "$f"\
              "$(awk -v var="${indArr[*]}" -v l="$len" -F '[ .]'\
              'BEGIN {split(var, varArr,  / /)}
              { for(i=1; i <NF; i++) resArray[i]=0 }
              { for(x in varArr) delete resArray[varArr[x]] }
              { y=0; for(x in resArray) {if(y==0) {printf "%s",$x; y=1} else {printf " %s",$x} }}
              { printf ".%s",$NF }' <<< "$f")"
    done
}

#array=${@:1:$(($#-1))}
#len=${#array[@]}

OPTIND=1

mutex=0

indArr=()
last=""
len=0

indStr=""
excStr=""


while getopts "i:x:" opt; do
    case "$opt" in
    i)
        if [[ $mutex -eq 0 ]]; then
            indStr=$OPTARG
            indArr=(${indStr//,/ })
            last=${indArr[-1]}

            unset 'indArr[${#arr[@]}-1]'
            len=${#indArr[@]}
            mutex=1
        fi
        ;;
    x)
        if [[ $mutex -eq 0 ]]; then
            excStr=$OPTARG
            indArr=(${excStr//,/ })

            mutex=1
        fi
    esac
done

if [[ ! -z $indStr ]]; then
    rename_i $indArr $last $len
elif [[ ! -z $excStr ]]; then
    rename_x $indArr
fi


