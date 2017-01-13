#!/usr/bin/env bash

# monthly-attendace-paper - A simple bash script that generates a monthly
# printout template to be used between an employer and employee.
#
# Written in 2017 by Franco Masotti/frnmst <franco.masotti@student.unife.it>
#
# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the public
# domain worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software. If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.

. ./configrc

declare -A days_string
days_string[Mon]="$Mon"
days_string[Tue]="$Tue"
days_string[Wed]="$Wed"
days_string[Thu]="$Thu"
days_string[Fri]="$Fri"
days_string[Sat]="$Sat"
days_string[Sun]="$Sun"

declare -A days_id
days_id[0]=Mon
days_id[1]=Tue
days_id[2]=Wed
days_id[3]=Thu
days_id[4]=Fri
days_id[5]=Sat
days_id[6]=Sun

###

printf "%s\n\n\n" "$title"
printf "%s\n\n" "$employer"
printf "%s\n\n" "$employee"
printf "%s\n" "$date_id"
printf "\n\n"

###

is_febuary="false"
if [ "$this_month" = "02" ]; then
    is_febuary="true"
fi

# Algorithm got from Wikipedia.
is_leap_year="false"
if [ $(($this_year % 4)) -ne 0 ]; then
    is_leap_year="false"
elif [ $(($this_year % 100)) -ne 0 ]; then
    is_leap_year="true"
elif [ $(($this_year % 400)) -ne 0 ]; then
    is_leap_year="false"
else
    is_leap_year="true"
fi

get_cal="$(cal -m $this_month $this_year | awk 'NF > 0' | tail -n +3)"

# Starting from monday (1) get the first and last day id of the month.
first_cal_line="$(printf "%s" "$get_cal" | head -n1)"
last_cal_line="$(printf "%s" "$get_cal" | tail -n1)"

first_day_id=$(printf "$first_cal_line" | wc -w)
first_day_id=$((7-$first_day_id+1))
first_day_id=$(($first_day_id-1))

last_day_id=$(printf "%s" "$last_cal_line" | wc -w)
last_day_number=$(echo $last_cal_line | awk "{print \$$last_day_id}")
last_day_id=$(($last_day_id-1))

day_offset=15
if [ "$is_febuary" = "true" ]; then
    day_offset=14
fi
month="$(seq 1 $day_offset)"

tabulation()
{
    printf "\t\t\t"
}

newline()
{
    printf "\n\n\n"
}

get_full_string()
{
    local day=$1
    local ds="$2"

    printf "$day/$this_month\t$ds"
}

print_day()
{
    local day=$1
    local day_id=$2
    local dd="${days_id[$day_id]}"
    local ds="${days_string[$dd]}"

    # If sunday
    if [ $dd = $highlited_day ]; then
        printf "||"
        get_full_string "$day" "$ds"
        printf "||"
    else
        printf "  "
        get_full_string "$day" "$ds"
        printf "  "
    fi
}

print_day_left()
{
    print_day $1 $2
    tabulation
}

print_day_right()
{
    print_day $1 $2
    newline
}

day_id=$first_day_id

for day in $month; do
    print_day_left $day $(($day_id % 7))
    print_day_right $(($day + $day_offset)) $((($day_id + $day_offset) % 7))

    day_id=$(($day_id + 1))
done

# Months with 31 days.
if [ $last_day_number -eq 31 ]; then
    tabulation
    printf "\t\t"
    print_day_right 31 $((($day_id + $day_offset) % 7))
fi

if [ "$is_leap_year" = "true" ]; then
    tabulation
    printf "\t\t"
    print_day_right 29 $((($day_id + $day_offset) % 7))
fi


printf "%s\n" "$format"
