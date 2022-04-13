#!/bin/bash -xe

if command -v arxiv_latex_cleaner > /dev/null 2>/dev/null;
then
    :
else
    echo >&2 "Please install arxiv_latex_cleaner"
    echo >&2 "  git clone https://github.com/google-research/arxiv-latex-cleaner"
    echo >&2 "  cd arxiv_latex_cleaner"
    echo >&2 "  python3 setup.py install"
    echo >&2 " (you might need to install zlib1g-dev and libjpeg8-dev packages first)"
    exit 1
fi

latex_template="$1"
package_file="$2"

packtmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'packtmpdir')
project_dir="$packtmpdir/project"
project_arxiv_dir="$packtmpdir/project_arXiv"
mkdir -p "$packtmpdir/project"

arxiv_main_file=ms.tex

copy_to_project()
{
    for f in "$@"
    do
        if [[ -r "$project_dir/$f" ]]
        then
            echo >&2 "The file '$f' will be overwritten. Something is wrong!!!"
            exit 1
        fi
    done
    cp "$@" "$project_dir/"
}

handle_subdir()
{
    subdir="$1"

    if [[ -d "$subdir" ]]
    then
        find $subdir -type f | while read f
        do
            nf=$(echo "$f" | perl -pne 's{^[^/]+/}{}; s{/}{-}')
            dst="$project_dir/$subdir-$nf"
            if [[ "$f" == *.tex ]]
            then
                perl helpers/flatten-structure.pl < "$f" > "$dst"
            else
                cp $f $dst
            fi
        done
    fi
}

handle_subdir images
handle_subdir figures
handle_subdir scores
handle_subdir inputs

for latex_file in *.tex
do
    if [[ "$latex_file" == "$arxiv_main_file" ]]
    then
        echo >&2 "Your repo cannot contain '$arxiv_main_file' file."
        echo >&2 "This file is restricted for arxiv purposes"
        exit 1
    fi

    target_file="$project_dir/$latex_file"

    if [[ "$latex_file" == "{{cookiecutter.paper_id}}.tex" ]]
    then
        target_file="$project_dir/$arxiv_main_file"
    fi

    perl helpers/flatten-structure.pl < "$latex_file" > "$target_file"
done

if [[ "$latex_template" == "vanilla" ]]
then
    :
elif [[ "$latex_template" == "tacl" ]]
then
    copy_to_project tacl2018v2.sty acl_natbib.bst
elif [[ "$latex_template" == "acl" ]]
then
     copy_to_project acl.sty acl_natbib.bst
elif [[ "$latex_template" == "nle" ]]
then
     copy_to_project nle.cls nlelike.bst cup_logo.eps cup_logo-eps-converted-to.pdf
elif [[ "$latex_template" == "sigconf" ]]
then
     copy_to_project acmart.cls ACM-Reference-Format.bst
elif [[ "$latex_template" == "pw-thesis" ]]
then
     :
elif [[ "$latex_template" == "coling" ]]
then
     copy_to_project coling2020.sty coling.bst
elif [[ "$latex_template" == "llncs" ]]
then
    copy_to_project llncs.cls splncs04.bst
elif [[ "$latex_template" == "emnlp" ]]
then
     copy_to_project emnlp2020.sty acl_natbib.bst
elif [[ "$latex_template" == "eacl" ]]
then
     copy_to_project eacl2021.sty acl_natbib.bst
elif [[ "$latex_template" == "neurips" ]]
then
     copy_to_project neurips_2021.sty
elif [[ "$latex_template" == "icml" ]]
then
     copy_to_project algorithm.sty \
                     algorithmic.sty \
                     fancyhdr.sty \
                     icml2022.bst \
                     icml2022.sty
elif [[ "$latex_template" == "ieee-access" ]]
then
     copy_to_project bullet.png ieeeaccess.cls IEEEtran.cls ieeeaccess.cls spotcolor.sty logo.png notaglinelogo.png
elif [[ "$latex_template" == "ieee-conf" ]]
then
     ;
elif [[ "$latex_template" == "poleval" ]]
then
     copy_to_project poleval.bst poleval.cls
else
    echo >&2 "Unknown template '$latex_template'!!!"
    exit 1
fi

copy_to_project bibliography.bib

perl -pne 's/^\s*\\usepackage\{xurl\}$//' -i "$project_dir/extras.tex"

heredir=`pwd`

main_source=ms
main_source_file="${main_source}.tex"

(cd "$project_dir" && pdflatex "$main_source_file" && bibtex "$main_source" && rm "${main_source}.pdf")

arxiv_latex_cleaner "$project_dir" --commands_to_delete '\todo'
perl -pne 's/\\bibliography\{bibliography\}/\\bibliography\{ms\}/' -i "$project_arxiv_dir/$main_source_file"
(cd "$project_arxiv_dir" && tar zvcf "$heredir/$package_file" .)
