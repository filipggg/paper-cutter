#!/bin/bash -xe

arxiv_package="$1"
target_pdf="$2"

gentmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'gentmpdir')

cp "$arxiv_package" "$gentmpdir/"

cd "$gentmpdir"

tar xvf "$arxiv_package"

for f in *
do
    if [[ -d "$f" ]]
    then
        echo >&2 "Unexpected directory: '$f'"
        exit 1
    fi
done

main_source=ms
main_source_file="${main_source}.tex"

pdflatex "$main_source_file"
pdflatex "$main_source_file"
pdflatex "$main_source_file"

cd -

cp "$gentmpdir/ms.pdf" "$target_pdf"
