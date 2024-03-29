#!/bin/bash

set -euo pipefail

PAPER_ID=lorem-ipsum
PAPER_DIR="${PAPER_ID}-paper"

check()
{
    config_file="$1"
    echo "========================================================================================="
    echo "*** TESTING $config_file"
    echo "========================================================================================="
    rm -rf "$PAPER_DIR"
    cookiecutter https://git.wmi.amu.edu.pl/filipg/paper-cutter.git --config-file "$config_file" --no-input --checkout master
    cd "$PAPER_DIR"
    make clean
    make
    if [[ "$config_file" != "configs/pw-thesis.yml" && "$config_file" != "configs/amu.yml" && "$config_file" != "configs/ieee-access.yml" && "$config_file" != "configs/amu-en.yml" ]]
    then
        make arxiv-$PAPER_ID.tar.gz
    fi
    cd ..
}

for config in configs/*.yml
do
    check $config
done
