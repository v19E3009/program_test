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

cat $@ | split -l 5000000 splited_access_log
for FILE in splited_access_log*; do
    if [ "$FLG_T" = "TRUE" ]; then
        cat FILE | awk -v AFTER="${AFTER}" -v BEFORE="${BEFORE}" ' AFTER < $4 && $4 <= BEFORE '|\\
        awk -F'[ :]' '{print $4,$5}' | sort | uniq -c | awk -F ' ' '{print $2,$1}' > Time_sone-$FILE
        cat FILE | awk -v AFTER="${AFTER}" -v BEFORE="${BEFORE}" ' AFTER < $4 && $4 <= BEFORE '|\\
        awk -F'[ :]' '{print $1}' | sort | uniq -c | sort -nr | awk -F ' ' '{print $2,$1}' > Remote_host-$FILE
    else
        cat < $Time_specified_file | awk -F'[ :]' '{print $4,$5}' | \
        sort | uniq -c | awk -F' ' '{print $2,$1}' > Time_sone-$FILE
        echo $Time_specified_file | awk '{print $1}' | sort | uniq -c |\
        sort -nr | awk -F' ' '{print $2,$1}' > Remote_host-$FILE

    
done
wait
echo "Number of accesses for each time zone"
cat Time_zone-splited_access_log* | awk '{a[$1] += $2} END{for(k in a) print k, a[k];}'
echo "Nuber of accesses by remote host"
cat Remote_host-splited_access_log* | awk '{b[$1] += $2} END{for(k in b) print k, b[k];}'

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

