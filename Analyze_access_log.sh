#!/bin/bash

usage () {
    cat <<EOM
Usage: $(basename "$0") [OPTION]...
    -h --help        Display help
    -t time          A explanetion for arg called t
EOM

    exit 2
}

while getopts ":t:h" optKey; do
    case "$optKey" in
        t)
            FLG_T="TRUE";
            AFTER=`echo $OPTARG | cut -f1 -d "-"`;
            BEFORE=`echo $OPTARG | cut -f2 -d "-"`;
            ;;
        '-h'|'--help'|*)
            usage
            ;;
   esac
done

shift `expr $OPTIND - 1`

if [ $# -eq 0 ]; then
    echo "The specified arguments are $#." 1>&2
    echo "Please require 1 or more arguments to execute" 1>&2
    exit 1
fi

#echo $@

if [ "$FLG_T" = "TRUE" ]; then
    #echo $AFTER
    #echo $BEFORE
    Time_specified_file=`cat $@ | awk -v AFTER="${AFTER}" -v BEFORE="${BEFORE}" ' AFTER < $4 && $4 <= BEFORE '`
    #Time_specified_file=cat $@ | awk '"$AFTER" < $4 && $4 <= "BEFORE"'
fi

#cat < $Time_specified_file

echo "Number of accesses for each time zone"
cat < $Time_specified_file | awk -F'[ :]' '{print $4,$5}' | sort | uniq -c | awk -F' ' '{print $2,$1}'

echo "Nuber of accesses by remote host"
#echo $Time_specified_file | awk '{print $1}' | sort | uniq -c | sort -nr | awk -F' ' '{print $2,$1}'

