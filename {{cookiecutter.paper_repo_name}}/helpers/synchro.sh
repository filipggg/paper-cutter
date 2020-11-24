#!/bin/bash -xe

. helpers/vars

if [[ "$OVERLEAF_GIT_URL" == "" ]]
then
    >&2 echo "Please set OVERLEAF_GIT_URL in `helpers/vars`"
    exit 1
fi

if [[ -e .git && ! -z "$(git status --untracked-files=no --porcelain)" ]]; then
    >&2 echo "Uncommited changes, commit your changes first"
    exit 1
fi

git remote add overleaf "$OVERLEAF_GIT_URL" || git remote set-url overleaf "$OVERLEAF_GIT_URL"

git config credential.helper "cache --timeout=10000000"

git pull origin master
git pull overleaf master

git push overleaf master
git push origin master
