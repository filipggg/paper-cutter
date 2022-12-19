Template for LaTeX papers
=========================

The template itself is in the `{{cookiecutter.paper_id}}-paper`.

In order to generate a project from the template:

* install cookiecutter
* find a paper-cutter tag applicable (usually the latest tag listed at <https://git.wmi.amu.edu.pl/filipg/paper-cutter/releases>), say 5.4.4
* run: `cookiecutter https://git.wmi.amu.edu.pl/filipg/paper-cutter.git --checkout 5.4.4`

You will be asked to choose a LaTeX template, at the moment the
following templates are handled:

* “Vanilla” — just a standard LaTeX article template (`vanilla`),
* TACL (`tacl`),
* ACL (`acl`),
* Natural Language Engineering journal (`nle`),
* ACM SIGCONF template (`sigconf`), e.g. for the SIGIR conference,
* MSc thesis at Warsaw University of Technology (`pw-thesis`)
* COLING (`coling`)
* LLNCS (`llncs`)
* EMNLP (`emnlp`)
* NeurIPS (`neurips`)
* ICML (`icml`)
* IEEE Access (`ieee-access`)
* IEEE Conf, e.g. FedCSIS (`ieee-conf`)
* PolEval (`poleval`)
* SCITEPRESS (`scitepress`, e.g. CSEDU conference)
* Msc thesis at Adam Mickiewicz University, Faculty of Mathematics and Computer Science (`amu`),
  template prepared by Bartłomiej Przybylski (https://github.com/bprzybylski/amuthesis)

If you are to use another template, prepare an MR to this repo first!
Do not add directly to your specific paper.

Interoperatibility with Overleaf
--------------------------------

Overleaf handles git but in an imperfect way (to put it mildly).
It's better to upload a package to Overleaf first.

You can do this by running `helpers/set-up-overleaf.sh` after creating a project
or carrying out the following steps manually:

1. Create a project locally.
2. Run `make`
3. Run `make source-pack`
4. Upload the zip file to Overleaf.
5. Copy project to some other place.
5. Clone the repo from Overleaf: `git clone https://git.overleaf.com/FUNNY-OVERLEAF-CODE PAPERID-paper`
6. Set remotes:

```
git remote add overleaf https://git.overleaf.com/FUNNY-OVERLEAF-CODE
git remote set-url origin YOUR-GIT-REPO
```

7. Set credential helper so that Overleaf won't ask about
   password: `git config credential.helper "cache --timeout=10000000"`
8. Unfortunately, Overleaf will discard hidden files (`.*`) when a zip
   is uploaded, also file permissions will be somewhat broken
9.  … so you need to copy `.cookiecutter.yml` file and re-apply the template (`cookiecutter https://git.wmi.amu.edu.pl/filipg/paper-cutter.git --checkout 5.4.4 --output-dir .. --config-file .cookiecutter.yml --no-input --overwrite-if-exists`)
10. Re-commit the files (including recovered `.*` files).
11. Push the repo to Overleaf (fortunately, the `.*` will be treated
   correctly when this is done by git): `git push overleaf master`
12. Push the repo to GitLab. `git push origin master`
13. Set the Overleaf git remote in `helpers/vars`
14. Now you can synchronize between GitLab repo and Overleaf manually or using `helpers/synchro.sh` script

Updating package with updated template
--------------------------------------

To keep your codebase in sync with template you need to occasionally reapply the template.
Here's how:

* find a paper-cutter tag applicable, say 5.4.4
* (do *not* refer to master in your projects!)
* go to project root
* run: `cookiecutter https://git.wmi.amu.edu.pl/filipg/paper-cutter.git --checkout 5.4.4 --output-dir .. --config-file .cookiecutter.yml --no-input --overwrite-if-exists`
* check changes with git

Editing the files
-----------------

Please do **not** modify the file `PAPER_ID.tex` (this file is
supplied by this template — and will be switched when you switch to
another journal/conference template, see below) . Modify
`metadata.tex` and `main.text` files.

If you really need to change `PAPER_ID.tex`, please prepare a merge
request to this template repo.

Switching to another conference/journal template
------------------------------------------------

Switching to another conference or journal template is easy.

1. Check whether the template is already handled. (See above for the list of LaTeX templates handled.)
   If not, get in touch with Filip Graliński.
2. Commit or stash any uncommitted changes.
3. Change the `latex_template` value accordingly in the `.cookiecutter.yml` file. Commit the changes.
4. Re-run the template (as if updating, see above: `cookiecutter https://git.wmi.amu.edu.pl/filipg/paper-cutter.git --checkout 5.4.4 --output-dir .. --config-file .cookiecutter.yml --no-input --overwrite-if-exists`).
5. Compare `metadata.tex` against the right metadata template file
   (`*/*-template-meta.tex` in `_latex-templates/`) and make any fixes
   needed. This is the only thing that needs to be done manually
   (unfortunately, LaTeX templates differ in commands for authors, their affiliations, etc.).
6. Run `make` to generate PDF.
7. If you have an appendix, make sure it is rendered correctly.

Adding new conference/journal template
--------------------------------------

You should prepare a merge request similar to <https://git.wmi.amu.edu.pl/filipg/paper-cutter/commit/970e10ca52bed1bf293f99809d89aacd5c7ca44a>.

Some notes:

* the style files should be just downloaded from an external resources (see e.g. https://git.wmi.amu.edu.pl/filipg/paper-cutter/src/branch/example/hooks/post_gen_project.sh#L87)
* you should take an example document (usually provided by the creators of a conference/journal template)
  and turn it into a template, like e.g. <https://git.wmi.amu.edu.pl/filipg/paper-cutter/src/branch/example/%7b%7bcookiecutter.paper_repo_name%7d%7d/_latex-templates/neurips-template.tex>
* metadata header (title, authors, etc.) should be given as a separate template file, see
  <https://git.wmi.amu.edu.pl/filipg/paper-cutter/src/branch/example/%7b%7bcookiecutter.paper_repo_name%7d%7d/_latex-templates/neurips-template-meta.tex>
* remember that [Jinja2](https://jinja.palletsprojects.com/en/3.0.x/) is used as the template engine
* sometimes you will need to add Jinja `{% raw %}` and `{% endraw %}` directives to escape LaTeX mark-up
  conflicting with Jinja directives (usually the whole or parts of `...-template.tex` and `...-template-meta.tex`
  files.

MacOS Requirements
------------

```
brew install cookiecutter
brew install texlive
brew install biber
brew install pyyaml
pip3 install syntok jinja2 arxiv_latex_cleaner
```

Versioning the template
-----------------------

Always use a specific tag in the `.gitlab-ci.yml` file for your
project when including `main.yml` from this repository.

This template is versioned with a Semantic-Versioning-like scheme, i.e.
a version is expected to be of the form M.N.P, where:

* _M_ is changed in case of breaking changes for which manual actions
  other then update with the `cookiecutter` command is required
* _N_ is changed when a new feature is added or a significant bugfix
  happened, it means that the files need to be updated in a project
  with the `cookiecutter` command
* _P_ is changed in case of minor changes or bugfixes, it should be OK even
  if changes are not update with the `cookiecutter` command

### Releasing a new version of the template

* change the version in the
  `{{cookiecutter.paper_id}}-paper/.gitlab-ci.yml` template file
* add an item to `CHANGELOG.md`
* in case of breaking changes (_M_ is incremented) describe clearly
  what actions are to be taken in `CHANGELOG.md`
* tag master with the version (the same as in `{{cookiecutter.paper_id}}-paper/.gitlab-ci.yml`)

Variables to be set in GitLab UI
--------------------------------

* `SLACK_RELEASE_BOT_SECRET` - secret to a Slack bot to inform about new releases
  (go to <https://YOUR_ORGANIZATION_NAME.slack.com/apps/manage/custom-integrations>, click
   "Incoming WebHooks" / "Add", then configure the hook and
   and set the string such as "ABCDEFGHI12/ABCDEFGHI12/aaaaaaaaaaaaaaaaaaaaaaaa"
   as `SLACK_RELEASE_BOT_SECRET`)

## Authors

Prepared by Filip Graliński (Applica.ai).

### Contributors

* Łukasz Garncarek
* Piotr Halama (including the project name)
* Tomasz Stanisławek
* Paweł Mleczko
