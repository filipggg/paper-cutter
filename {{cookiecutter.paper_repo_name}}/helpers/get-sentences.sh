#!/bin/bash

bash helpers/pdf-to-plain-text.sh "$1" | perl helpers/strip-references.pl | perl -pne 'chomp $_; $_.=" "' | python3 -m syntok.segmenter
