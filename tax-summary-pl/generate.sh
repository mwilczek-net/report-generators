#!/bin/bash

CURRENT_PATH="$(cd "$(dirname "$0")" && pwd -P)"

MONTHS=("Styczeń" "Luty" "Marzec" "Kwiecień" "Maj" "Czerwiec" "Lipiec" "Sierpień" "Wrzesień" "Październik" "Listopad" "Grudzień")

report_template="${CURRENT_PATH}/0000-00/0000-00 kwoty.fods"

echo -n "Year (i.e. 2021): "
read year_input

echo -n "Month (1 - 12): "
read month_input


month_name="${MONTHS[$month_input-1]}"
month_input="0${month_input}"
month_input_len=${#month_input}

month_input=${month_input:month_input_len-2:2}


report_dir="${CURRENT_PATH}/${year_input}-${month_input}"
report_file="${report_dir}/${year_input}-${month_input} kwoty.fods"

if [ -f "${report_file}" ]; then
    echo ""
    echo "ERROR!"
    echo "Report already generated!"
    exit 1
fi

echo -n "Zus (PLN): "
read zus_input

echo -n "PPE (PLN): "
read ppe_input

echo -n "VAT (PLN): "
read vat_input

zus_input="${zus_input/,/.}"
ppe_input="${ppe_input/,/.}"
vat_input="${vat_input/,/.}"

zus_input="${zus_input// }"
ppe_input="${ppe_input// }"
vat_input="${vat_input// }"


cat <<EOF
Katalog:
${year_input}-${month_input}
${report_dir}

Raport:
${month_name} ${year_input}
ZUS: ${zus_input}
PPE: ${ppe_input}
VAT: ${vat_input}
${report_file}
EOF

echo -n "Any enter key to generate report"
read

mkdir -p "${report_dir}"

cat "${report_template}" | sed "s|__MONTH_PLACEHOLDER__|${month_name}|g" | sed "s|__YEAR_PLACEHOLDER__|${year_input}|g" | sed "s|__ZUS_PLACEHOLDER__|${zus_input}|g" | sed "s|__PPE_PLACEHOLDER__|${ppe_input}|g" | sed "s|__VAT_PLACEHOLDER__|${vat_input}|g" > "${report_file}"
