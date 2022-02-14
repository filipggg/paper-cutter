#!/bin/bash -e

echo "Setting up interoperability with Overleaf..."
echo "Note that you need ability to clone repos from Overleaf."

original_git_url=$(git remote get-url origin)

echo "Make sure $original_git_url exists at your git server."
echo "It should be created as en empty repo, *uncheck* option"
echo "'Initialize repository with a README' or similar."

echo ""
echo "Press ENTER to start"
read

here_dir=$(basename $PWD)


make
make source-pack

source_pack={{cookiecutter.paper_id}}.zip

echo ""
echo "Go to Overleaf, click New Project / Upload Project,"
echo "then upload $source_pack from here ($(pwd)/$source_pack)"

echo ""
echo "When it is uploaded, click Menu / Git, copy the URL"
echo "(something like https://git.overleaf.com/123456789ec0830001af836f),"
echo "paste here and press ENTER"

read
overleaf_git_url=$REPLY
# remove "git clone" in case it was directly copied from Overleaf
overleaf_git_url=${overleaf_git_url#git clone }
overleaf_git_id=$(basename $overleaf_git_url)


cd ..

backup_dir=${here_dir}-backup
mv $here_dir ${here_dir}-backup

git clone $overleaf_git_url $here_dir

cd $here_dir

git remote add overleaf $overleaf_git_url
git remote set-url origin $original_git_url

git config credential.helper "cache --timeout=10000000"

cp ../$backup_dir/.cookiecutter.yml .

git add .cookiecutter.yml
git commit -m 'Back cookiecutter config'

cookiecutter https://git.wmi.amu.edu.pl/filipg/paper-cutter.git --checkout 5.2.3 --output-dir .. --config-file .cookiecutter.yml --no-input --overwrite-if-exists

git add --all
git commit -m 'Bring back all the files'

perl -pne 's{OVERLEAF_GIT_URL=}{OVERLEAF_GIT_URL='$overleaf_git_url'}' -i helpers/vars

git add helpers/vars
git commit -m 'Set vars'

git push overleaf master
git push origin master

cd ..

echo "DONE"
echo "Left ${backup_dir}, now type 'cd ..' and you can remove it"
