function bq_load_csv_autodetect() {
    bq load --source_format=CSV \
            --skip_leading_rows=1 \
            --autodetect \
            $1 $2
}

function visidata_csv_to_trend() {
    cat $1 | jq "reduce .[] as \$item ({}; . + {(\$item.${2:-day}): \$item.${3:-count}})"
}
