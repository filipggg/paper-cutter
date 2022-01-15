#!/bin/bash -xe

get_files()
{
    url=$1
    shift
    dump_dir=$(mktemp -d)
    dumped_file=$dump_dir/file.zip
    wget -O $dumped_file "$url"
    (cd $dump_dir && unzip -j file.zip)
    for file in $@
    do
        sfile=$dump_dir/$file
        if [[ -r $sfile ]]
        then
            cp $sfile .
        else
            echo >&2 "Cannot find '$file' in '$url'"
            exit 1
        fi
    done
}

fix_noexpand_issue()
{
    # see https://tex.stackexchange.com/questions/487428/patch-failed-in-emnlp-style-template
    file_to_be_patched="$1"
    sed -i 's|{\\errmessage{\\noexpand patch failed}}|{}|g' "$1"
}

if [ "{{ cookiecutter.latex_template }}" = "vanilla" ]; then
    cp -r _latex-templates/vanilla-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/vanilla-template-meta.tex metadata.tex
elif [ "{{ cookiecutter.latex_template }}" = "tacl" ]; then
    wget 'https://transacl.org/tacl-submission-templates/tacl2018v2.sty'
    wget 'https://transacl.org/tacl-submission-templates/acl_natbib.bst'
    cp -r _latex-templates/tacl2018v2-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/tacl2018v2-template-meta.tex metadata.tex
elif [ "{{ cookiecutter.latex_template }}" = "acl" ]; then
    wget 'https://raw.githubusercontent.com/acl-org/acl-style-files/master/latex/acl.sty'
    wget 'https://raw.githubusercontent.com/acl-org/acl-style-files/master/latex/acl_natbib.bst'
    # fix_noexpand_issue acl2020.sty
    cp -r _latex-templates/acl-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/acl-template-meta.tex metadata.tex
    if [ "{{ cookiecutter.with_appendix }}" = "yes" ]; then
        cp -r _latex-templates/acl-template-appendix.tex the-appendix.tex
    fi
elif [ "{{ cookiecutter.latex_template }}" = "nle" ]; then
    cp -r _latex-templates/nle-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/nle-template-meta.tex metadata.tex
elif [ "{{ cookiecutter.latex_template }}" = "sigconf" ]; then
    cp -r _latex-templates/sigconf-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/sigconf-template-meta.tex metadata.tex
elif [ "{{ cookiecutter.latex_template }}" = "pw-thesis" ]; then
    cp -r _latex-templates/pw-thesis-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/pw-thesis-template-meta.tex metadata.tex
    cp -r _latex-templates/pw-thesis-template-titlepage-en.tex titlepage.tex

    cp -r _optional_files/_pw-thesis/* .
elif [ "{{ cookiecutter.latex_template }}" = "coling" ]; then
    get_files "https://coling2020.org/coling2020.zip" \
              coling2020/coling.bst \
              coling2020/coling2020.sty
    cp -r _latex-templates/coling2020-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/coling2020-template-meta.tex metadata.tex
elif [ "{{ cookiecutter.latex_template }}" = "llncs" ]; then
    get_files "ftp://ftp.springernature.com/cs-proceeding/llncs/llncs2e.zip" \
              llncs.cls \
              splncs04.bst
    cp -r _latex-templates/llncs-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/llncs-template-meta.tex metadata.tex
elif [ "{{ cookiecutter.latex_template }}" = "emnlp" ]; then
    get_files "https://2020.emnlp.org/files/emnlp2020-templates.zip" \
              acl_natbib.bst \
              emnlp2020.sty
    cp -r _latex-templates/emnlp2020-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/emnlp2020-template-meta.tex metadata.tex
    cp -r _latex-templates/emnlp2020-template-appendix.tex the-appendix.tex
elif [ "{{ cookiecutter.latex_template }}" == "neurips" ]; then
    rm -f neurips_2021.sty
    wget https://media.neurips.cc/Conferences/NeurIPS2021/Styles/neurips_2021.sty
    cp -r _latex-templates/neurips-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/neurips-template-meta.tex metadata.tex
    cp -r _latex-templates/neurips-checklist.tex checklist.tex
elif [ "{{ cookiecutter.latex_template }}" == "icml" ]; then
    get_files "https://media.icml.cc/Conferences/ICML2022/Styles/icml2022.zip" \
              algorithm.sty \
              algorithmic.sty \
              fancyhdr.sty \
              icml2022.bst \
              icml2022.sty
    cp -r _latex-templates/icml-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/icml-template-meta.tex metadata.tex
elif [ "{{ cookiecutter.latex_template }}" == "ieee-access" ]; then
    get_files "https://template-selector.ieee.org/api/ieee-template-selector/template/541/download" \
              bullet.png \
              ieeeaccess.cls \
              IEEEtran.cls \
              ieeeaccess.cls \
              spotcolor.sty \
              logo.png \
              notaglinelogo.png
    cp -r _latex-templates/ieee-access-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/ieee-access-template-meta.tex metadata.tex
    cp -r _latex-templates/ieee-access-template-biographies.tex biographies.tex
    mkdir -p images
    cp -r _latex-templates/ieee-access-template-photo.png images/sample-photo.png
    # not compatible with tikz (and todonotes which is based on tikz)
    sed -i 's/\\usepackage\[textsize=tiny\]{todonotes}/\\usepackage{todo}/' other-extras.tex
elif [ "{{ cookiecutter.latex_template }}" = "poleval" ]; then
    cp -r _latex-templates/poleval-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/poleval-template-meta.tex metadata.tex
    cp -r _latex-templates/poleval.{bst,cls} .
elif [ "{{ cookiecutter.latex_template }}" = "amu" ]; then
    cp -r _latex-templates/amu-template.tex {{cookiecutter.paper_id}}.tex
    cp -r _latex-templates/amu-template-meta.tex metadata.tex
    get_files "https://github.com/bprzybylski/amuthesis/archive/master.zip" \
              amuthesis.cls \
              uam-logo.pdf
fi

if [ "{{ cookiecutter.with_appendix }}" = "yes" ]; then
    cp -r _optional_files/_appendix/* .
fi

if [ "{{ cookiecutter.extra_locale }}" = "pl_PL" -o "{{ cookiecutter.locale }}" = "pl_PL" ]; then
    cp -r _optional_files/_pl_files/* .
fi

rm -rf _latex-templates _optional_files

if [ -e .git ]; then
    git checkout README.md main.tex abstract.tex preamble.tex metadata.tex bibliography.bib contributions.yaml
    for f in helpers/vars abstract-pl.tex keywords.tex keywords-pl.tex appendix.tex
    do
        git checkout $f || true
    done
else
    git init
    git add --all
    git commit -m 'init'
    git remote add origin git@{{cookiecutter.git_host}}:{{cookiecutter.gitlab_group}}/{{cookiecutter.paper_repo_name}}.git
fi
