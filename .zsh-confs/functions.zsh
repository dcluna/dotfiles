function bq_load_csv_autodetect() {
    bq load --source_format=CSV \
            --skip_leading_rows=1 \
            --autodetect \
            $1 $2
}

function bq_load_tsv_autodetect() {
    bq load --source_format=CSV \
       --field_delimiter=tab \
       --skip_leading_rows=1 \
       --autodetect \
       $1 $2
}

function bq_load_parquet() {
    bq load --source_format=PARQUET $1 $2
}

function visidata_csv_to_trend() {
    cat $1 | jq "reduce .[] as \$item ({}; . + {(\$item.${2:-day}): \$item.${3:-count}})"
}

function fileio_upload() {
    curl -F "file=@$1" "https://file.io/?expires=1"
}
