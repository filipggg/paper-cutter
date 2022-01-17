#!/bin/bash

if [[ "$TEMPLATE_REPO_URL" == "" ]]
then
    echo >&2 "Set the TEMPLATE_REPO_URL variable!"
    exit 1
fi

echo 'gitlab-runner launched locally does not handle `include` directives.'
echo 'THIS IS AN UGLY WORK-AROUND FOR https://gitlab.com/gitlab-org/gitlab-runner/issues/3327'

template_version=$(grep -P "^\s*ref:\s*'[0-9.]+'\s*$" .gitlab-ci.yml | grep -o -P '[0-9.]+')

cookiecutter_paper_dir=`mktemp -d -t run-gitlab-runner.XXXXXXXXXXX`
(cd $cookiecutter_paper_dir && git clone ${TEMPLATE_REPO_DIR} -b $template_version)

new_gitlab_ci_yml=`mktemp -t new-gitlab-ci-yml.XXXXXXXXX`

perl -ne 'print if 1../THIS IS AN UGLY WORK-AROUND/' < .gitlab-ci.yml > $new_gitlab_ci_yml
cat ${cookiecutter_paper_dir}/cookiecutter-*-paper/main.yml >> $new_gitlab_ci_yml

cp $new_gitlab_ci_yml .gitlab-ci.yml

current_commit=`git rev-parse HEAD`

# committing the manufactured .gitlab-ci.yml for a moment
git add .gitlab-ci.yml
git commit -m 'TEMPORARY COMMIT. DO NOT MERGE'

gitlab-runner exec docker "$@"

# going back to the original commit
git reset --hard $current_commit
