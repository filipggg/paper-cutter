#!/bin/bash

here_dir=$(dirname "$0")

pdf_file="$1"

if [[ "$pdf_file" == "" ]]
then
    >&2 echo "no file given"
    exit 1
fi

perl -e 'print "PHYSICAL PAGES\tCHARACTERS WITH SPACES\tSTANDARD PAGES\n"'
pages=$(pdfinfo "$1" | perl -ne 'print "$1\n" if /Pages:\s+(\d+)/')
chars=$(bash $here_dir/pdf-to-plain-text.sh "$1" | wc -m)
spages=$(echo "scale=1; $chars / 1800.0" | bc)
echo "$pages	$chars	$spages"
