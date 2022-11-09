#!/bin/bash

pdftotext "$1" - | grep -F -v 'Confidential Review Copy' | grep -E -v '^(ACL 2020 Submission \*\*\*\. Confidential Review Copy\. DO NOT DISTRIBUTE\.|Anonymous ACL submission|Abstract|Results|Conclusions|https?://\S+)\s*$' | grep '[^[:space:]]' | grep -E '[a-zA-Z]{2}' | perl -pne 's/\f//g;' | uniq
