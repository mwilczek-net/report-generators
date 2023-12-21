#!/bin/zsh
# set -x

CURRENT_PATH="$(cd "$(dirname "$0")" && pwd -P)"
TEMPLATES="${CURRENT_PATH}/templates"

function read_date {
    # local date_value
    date_value=`dialog --stdout --title "OUT OF THE OFFICE" --date-format "%Y-%m-%d" --calendar "Please choose ${2}" 0 0`
    eval "$1=${date_value}"
}

function clear_terminal {
    printf '\033[2J'
}

function print_summary {
cat <<EOF
Generate Out Of The Office message:
Start Date: ${date_from}
End Date: ${date_to}
EOF
}

function confirm_generation {
    echo -n "Any enter key to generate report"
    read
}


date_from=""
date_to=""
read_date date_from "START DATE"
read_date date_to "END DATE"


clear_terminal
print_summary
confirm_generation
