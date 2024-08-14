#!/bin/zsh
# set -x

CURRENT_PATH="$(cd "$(dirname "$0")" && pwd -P)"
TEMPLATES="${CURRENT_PATH}/templates"
RESULTS="${CURRENT_PATH}/results"

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


function process_file {
    local file_name
    local templates_directory
    local results_dir

    file_name="${1}"
    templates_directory="${2}"
    results_dir="${3}"

    echo "Process template \"${templates_directory}/${file_name}\""
    cat "${TEMPLATES}/${templates_directory}/${file_name}" | sed "s|%DAY_FROM%|${date_from}|g" | sed "s|%DAY_TO%|${date_to}|g" > "${RESULTS}/${results_dir}/${file_name}"
}

function generate_messages {
    local selected_templates
    local template_files
    local file
    local results_dir

    selected_templates="${1}"
    pushd "${TEMPLATES}/${selected_templates}"
    template_files=(${(@f)"$(ls -1)"})
    popd

    results_dir="$(date '+%Y-%m-%d %H.%M.%S') - ${selected_templates}"

    mkdir -p "${RESULTS}/${results_dir}"
    for file in $template_files; do
        process_file "${file}" "${selected_templates}" "${results_dir}"
    done
}

function list_template_directories {
    local templates
    local templates_directories

    pushd "${TEMPLATES}"
    templates_directories=(${(@f)"$(ls -1)"})
    popd

    echo ""
    echo "Select templates directory"
    echo "CTRL+D for exit"
    select templates in $templates_directories; do
        list_templates_in_directory "${templates}";
        confirm_generation
        generate_messages "${templates}"
    done
}



date_from=""
date_to=""
read_date date_from "START DATE"
read_date date_to "END DATE"

clear_terminal
print_dates_summary
list_template_directories





