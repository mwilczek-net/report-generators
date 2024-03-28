#!/bin/zsh
# set -x

CURRENT_PATH="$(cd "$(dirname "$0")" && pwd -P)"
TEMPLATES="${CURRENT_PATH}/templates"

function read_date {
    local date_value
    date_value=`dialog --stdout --title "OUT OF THE OFFICE" --date-format "%Y-%m-%d" --calendar "Please choose ${2}" 0 0`
    eval "$1=${date_value}"
}

function clear_terminal {
    printf '\033[2J'
}
function print_dates_summary {
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

function list_templates_in_directory {
    local selected_directory
    local templates


    selected_templates="${1}"
    selected_directory="${TEMPLATES}/${selected_templates}"

    echo "Generating results form templates \"${selected_templates}\""

    pushd "${selected_directory}"
    templates=(${(@f)"$(ls -1)"})
    echo $templates
    popd
}


function list_template_directories {
    local templates
    local templates_directories

    pushd "${TEMPLATES}"
    templates_directories=(${(@f)"$(ls -1)"})
    popd

    echo "Select templates directory"
    echo "CTRL+D for exit"
    select templates in $templates_directories; do
        list_templates_in_directory "${templates}";
    done
}



date_from=""
date_to=""
read_date date_from "START DATE"
read_date date_to "END DATE"

clear_terminal
print_dates_summary
list_template_directories
confirm_generation





