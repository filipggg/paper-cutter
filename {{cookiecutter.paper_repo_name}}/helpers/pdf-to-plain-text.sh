#!/bin/bash

pdftotext "$1" - | fgrep -v 'Confidential Review Copy' | grep -P -v '^(ACL 2020 Submission \*\*\*\. Confidential Review Copy\. DO NOT DISTRIBUTE\.|Anonymous ACL submission|Abstract|Results|Conclusions|https?://\S+)\s*$' | grep '[^[:space:]]' | egrep '[a-zA-Z]{2}' | perl -pne 's/\f//g;' | uniq
