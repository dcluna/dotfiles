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

function jsonl_to_json() {
  jq -s '.' "$1"
}

function json_to_jsonl() {
    jq -c '.[]' "$1"
}

# Show files under docs/ added only in the current branch
function git-docs-added() {
    local base current
    current=$(git branch --show-current) || return 1
    base=$(git config --get "branch.${current}.merge" 2>/dev/null | sed 's|refs/heads/||')
    if [[ -z "$base" ]]; then
        for b in develop main master; do
            git rev-parse --verify "$b" &>/dev/null && base=$b && break
        done
    fi
    [[ -z "$base" ]] && echo "Could not determine base branch" >&2 && return 1
    git diff --name-only --diff-filter=A "$(git merge-base HEAD "$base")" HEAD -- docs/
}
