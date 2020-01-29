#!/usr/bin/env bash
#
# monthly-attendace-paper - A simple bash script that generates a monthly
# printout template to be used between an employer and employee.
#
# Written in 2017-2020 by Franco Masotti/frnmst <franco.masotti@live.com>
#
# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the public
# domain worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software. If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.

set -euo pipefail

CONFIG="${1}"
. "${CONFIG}"

declare -A days_string
days_string[MON]="${MON}"
days_string[TUE]="${TUE}"
days_string[WED]="${WED}"
days_string[THU]="${THU}"
days_string[FRI]="${FRI}"
days_string[SAT]="${SAT}"
days_string[SUN]="${SUN}"

declare -A days_id
days_id[0]=MON
days_id[1]=TUE
days_id[2]=WED
days_id[3]=THU
days_id[4]=FRI
days_id[5]=SAT
days_id[6]=SUN

get_full_string()
{
    local day=${1}
    local ds="${2}"

    printf "%s\t%s" ""${day}"/"${THIS_MONTH}"" "${ds}"
}

print_day()
{
    local day=${1}
    local day_id=${2}
    local dd="${days_id[$day_id]}"
    local ds="${days_string[$dd]}"

    # By default: SUN.
    if [ "${dd}" = "${HIGHLITED_DAY}" ]; then
        printf "%s" "${HIGHLITED_DAY_DELIMITER}"
        get_full_string "${day}" "${ds}"
        printf "%s" "${HIGHLITED_DAY_DELIMITER}"
    else
        printf "%s" "${NON_HIGHLITED_DAY_DELIMITER}"
        get_full_string "${day}" "${ds}"
        printf "%s" "${NON_HIGHLITED_DAY_DELIMITER}"
    fi
}

print_day_left()
{
    print_day ${1} ${2}
    ${TABULATION_FOR_STANDARD_DAYS}
}

print_day_right()
{
    print_day ${1} ${2}
    ${NEWLINE}
}

# Header.
printf "%s\n\n\n" "${TITLE}"
printf "%s\n\n" "${EMPLOYER}"
printf "%s\n\n" "${EMPLOYEE}"
printf "%s\n" "${DATE_ID}"
printf "\n\n"

is_febuary='false'
if [ "${THIS_MONTH}" = '2' ] || [ "${THIS_MONTH}" = '02' ]; then
    is_febuary='true'
fi

# Algorithm from Wikipedia.
# Creative Commons Attribution-ShareAlike License 3.0
# https://creativecommons.org/licenses/by-sa/3.0/
# See https://en.wikipedia.org/wiki/Leap_year#Algorithm
is_leap_year='false'
if [ $((${THIS_YEAR} % 4)) -ne 0 ]; then
    is_leap_year='false'
elif [ $((${THIS_YEAR} % 100)) -ne 0 ]; then
    is_leap_year='true'
elif [ $((${THIS_YEAR} % 400)) -ne 0 ]; then
    is_leap_year='false'
else
    is_leap_year='true'
fi

get_cal="$(cal --monday ${THIS_MONTH} ${THIS_YEAR} | awk 'NF > 0' | tail --lines=+3)"

# Starting from monday (1) get the first and last day id of the month.
first_cal_line="$(printf "%s" "${get_cal}" | head --lines=1)"
last_cal_line="$(printf "%s" "${get_cal}" | tail --lines=1)"

first_day_in_month_id_reverse=$(printf "${first_cal_line}" | wc --words)
first_day_in_month_id=$((7 - ${first_day_in_month_id_reverse} + 1))
first_day_in_month_id=$((${first_day_in_month_id} - 1))

last_day_in_month_id=$(printf "%s" "${last_cal_line}" | wc --words)
last_day_in_month_number=$(echo ${last_cal_line} | awk "{print \$$last_day_in_month_id}")
last_day_in_month_id=$((${last_day_in_month_id} - 1))

day_offset=15
if [ "${is_febuary}" = 'true' ]; then
    day_offset=14
fi

half_month="$(seq 1 ${day_offset})"
day_id=${first_day_in_month_id}
for day in ${half_month}; do
    print_day_left ${day} $((${day_id} % 7))
    print_day_right $((${day} + ${day_offset})) $(((${day_id} + ${day_offset}) % 7))

    day_id=$((${day_id} + 1))
done

# Months with 31 days.
if [ ${last_day_in_month_number} -eq 31 ]; then
    ${TABULATION_FOR_STANDARD_DAYS}
    ${TABULATION_FOR_IRREGULAR_DAYS}
    print_day_right 31 $(((${day_id} + ${day_offset}) % 7))
fi

# February in a leap year.
if [ "${is_febuary}" = 'true' ] && [ "${is_leap_year}" = 'true' ]; then
    ${TABULATION_FOR_STANDARD_DAYS}
    ${TABULATION_FOR_IRREGULAR_DAYS}
    print_day_right 29 $(((${day_id} + ${day_offset}) % 7))
fi

printf "%s\n" "${FORMAT}"

