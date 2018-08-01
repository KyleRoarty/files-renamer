#!/bin/bash

show_help() {
    echo "Splits on space, _, i includes, x excludes"
    echo "renameFiles.sh -i <num>[,<num>,<num>,...]"
    echo "renameFiles.sh -x <num>[,<num>,<num>,...]"
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
    len=${#indArr[@]}

    for f in *.*
    do
        if [[ ! -z "$last" ]]; then
            mv -- "$f"\
                  "$(awk -v var="${indArr[*]}" -v l="$len" -v num="$last" -F '[ ._]'\
                     'BEGIN {split(var, varArr, / /)}
                      { for(x in varArr) printf "%s ",$varArr[x] }
                      { printf "- " }
                      { printf "%s.%s",$num,$NF }' <<< "$f")"
        else
            mv -- "$f"\
                  "$(awk -v var="${indArr[*]}" -F '[ ._]'\
                    'BEGIN {split(var, varArr, / /)}
                     { printf "%s.%s",$var,$NF }' <<< "$f")"
        fi
    done
}

# Rename excluding passed numbers
rename_x(){
    indArr=$1

    for f in *.*
    do
        mv -- "$f"\
              "$(awk -v var="${indArr[*]}" -F '[ ._]'\
              'BEGIN {split(var, varArr,  / /)}
              { for(i=1; i <NF; i++) resArray[i]=0 }
              { for(x in varArr) {if(varArr[x] < 0) varArr[x]=NF+varArr[x]; delete resArray[varArr[x]]} }
              { y=0; for(x in resArray) {if(y==0) {printf "%s",$x; y=1} else {printf " %s",$x} }}
              { printf ".%s",$NF }' <<< "$f")"
    done
}

OPTIND=1

mutex=0

indArr=()
last=""

indStr=""
excStr=""


while getopts "i:x:h" opt; do
    case "$opt" in
    i)
        if [[ $mutex -eq 0 ]]; then
            indStr=$OPTARG
            indArr=(${indStr//,/ })
            last=${indArr[-1]}
            unset 'indArr[${#arr[@]}-1]'
            mutex=1
        fi
        ;;
    x)
        if [[ $mutex -eq 0 ]]; then
            excStr=$OPTARG
            indArr=(${excStr//,/ })

            mutex=1
        fi
        ;;
    h)
        show_help
    esac
done


if [[ ! -z $indStr ]]; then
    rename_i $indArr $last
elif [[ ! -z $excStr ]]; then
    rename_x $indArr
fi


