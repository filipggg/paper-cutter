#!/bin/bash

input_file="$1"
method="$2"

extract_text() {
    if [[ "$method" == "from-tex" ]]
    then
        detex "$input_file" | grep -E '\S' | grep -v 'unsrt' | perl -pne 's/^\s+| +$//g'
    else
        bash helpers/pdf-to-plain-text.sh "$input_file" | perl helpers/strip-references.pl | perl -pne 'chomp $_; $_.=" "'
    fi
}

extract_text | python3 -m syntok.segmenter | grep -E '\S'
