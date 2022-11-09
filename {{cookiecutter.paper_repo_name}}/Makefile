SHELL=/bin/bash

# Do not edit these values, they should be changed by modifying .cookiecutter.yml
# and re-applying the template
PAPER_ID={{cookiecutter.paper_id}}
HAS_APPENDIX={{cookiecutter.with_appendix}}
LATEX_TEMPLATE={{cookiecutter.latex_template}}
WITH_ARXIV_PACKAGE={{cookiecutter.with_arxiv_package}}

CONTENT_TEX_SOURCES=$(filter-out $(PAPER_ID).tex config.tex extras.tex metadata.tex preamble.tex the-appendix.tex, $(shell find . -name '*.tex'))

CURRENT_DIR=$(shell pwd)
AUTOZOIL_DIR?=/opt/autozoil
AUTOZOIL_LOCALE={{cookiecutter.locale}}

EXTERNAL_PLAIN_TEXT_CHECKER=

space := $(subst ,, )

ifneq (,$(wildcard appendix.tex))
ifeq ($(LATEX_TEMPLATE),acl)
IS_APPENDIX_SEPARATE=yes
endif
ifeq ($(LATEX_TEMPLATE),eacl)
IS_APPENDIX_SEPARATE=yes
endif
endif

ifeq ($(IS_APPENDIX_SEPARATE),yes)
HAS_SUPPLEMENT=yes
endif

ifeq ($(LATEX_TEMPLATE),pw-thesis)
EXTRA_PDFS=titlepage.pdf
endif

CONTENT_TEX_SOURCES_WITH_DIR := $(addprefix $(CURRENT_DIR)/, $(CONTENT_TEX_SOURCES))
SCOREFILES=$(shell perl extract-score-files.pl $(CONTENT_TEX_SOURCES))

clean_latex_stuff=rm -rf *.aux *.nav *.toc *.log *.out *.blg *.bbl autozoil-log.txt autozoil.xml the-appendix.pdf supplement.zip $(PAPER_ID).pdf $(PAPER_ID).zip arxiv-$(PAPER_ID).pdf arxiv-$(PAPER_ID).tar.gz abstract.txt sentences.txt stats.txt $(EXTRA_PDFS) helpers/$(PAPER_ID)-contribution-declaration.tex helpers/$(PAPER_ID)-contribution-declaration.pdf helpers/*.aux helpers/*.bbl helpers/*.bcf helpers/*.blg helpers/*.log helpers/*.run.xml

ifeq ($(HAS_SUPPLEMENT),yes)
{% if cookiecutter.contribution_declaration == 'yes' %}
all: $(PAPER_ID).pdf abstract.txt supplement.zip stats.txt sentences.txt helpers/$(PAPER_ID)-contribution-declaration.pdf
{% else %}
all: $(PAPER_ID).pdf abstract.txt supplement.zip stats.txt sentences.txt
{% endif %}
else
{% if cookiecutter.contribution_declaration == 'yes' %}
all: $(PAPER_ID).pdf abstract.txt stats.txt sentences.txt helpers/$(PAPER_ID)-contribution-declaration.pdf
{% else %}
all: $(PAPER_ID).pdf abstract.txt stats.txt sentences.txt
{% endif %}
endif

source-pack: $(PAPER_ID).zip

stats.txt: $(PAPER_ID).pdf helpers/stats.sh
	bash helpers/stats.sh $< > $@
	cat $@

{% if cookiecutter.beeminder_support == 'yes' %}
logbeeminder: helpers/logbeeminder.py stats.txt
	python3	$<
{% endif %}

$(PAPER_ID).pdf: $(PAPER_ID).tex preamble.tex metadata.tex $(CONTENT_TEX_SOURCES) bibliography.bib $(SCOREFILES) $(EXTRA_PDFS)
	pdflatex $<
	bibtex $(PAPER_ID)
	pdflatex $<
	pdflatex $<

# to be copied and pasted as plain text (without LaTeX stuff)
abstract.txt: abstract.tex
	cat $< | perl -pne 's/noqa\{[^}]+\}//g' | detex > $@

SENTENCE_EXTRACTION_METHOD=from-pdf

ifeq ($(LATEX_TEMPLATE),amu)
ifeq ($(AUTOZOIL_LOCALE),pl_PL)
SENTENCE_EXTRACTION_METHOD=from-tex
endif
endif

ifeq ($(SENTENCE_EXTRACTION_METHOD),from-tex)
sentences.txt: $(PAPER_ID).tex helpers/get-sentences.sh helpers/pdf-to-plain-text.sh helpers/strip-references.pl
	bash helpers/get-sentences.sh $< from-tex > $@
else
sentences.txt: $(PAPER_ID).pdf helpers/get-sentences.sh helpers/pdf-to-plain-text.sh helpers/strip-references.pl
	bash helpers/get-sentences.sh $< > $@
endif

scores/%.txt:
	mkdir -p scores
	curl "https://gonito.net/api/txt/score/$(subst $(space),%20,$*)" -o "$@"

autozoil-log.txt: $(CONTENT_TEX_SOURCES)
	cd $(AUTOZOIL_DIR) && set -o pipefail && ./autozoil --locale $(AUTOZOIL_LOCALE) $(CONTENT_TEX_SOURCES_WITH_DIR) --alt-log-file $(CURRENT_DIR)/$(PAPER_ID).log | tee $(CURRENT_DIR)/$@


ifeq ($(EXTERNAL_PLAIN_TEXT_CHECKER),)
autozoil: autozoil.xml
else
autozoil: autozoil.xml autozoil-external-check.xml

autozoil-external-check.xml: sentences.txt
	curl -X POST -H "Content-Type: multipart/form-data" -F "file=@sentences.txt" $(EXTERNAL_PLAIN_TEXT_CHECKER) > $@
endif

autozoil.xml: $(CONTENT_TEX_SOURCES)
	cd $(AUTOZOIL_DIR) && set -o pipefail && ./autozoil --locale $(AUTOZOIL_LOCALE) $(CONTENT_TEX_SOURCES_WITH_DIR) --format xml --alt-log-file $(CURRENT_DIR)/$(PAPER_ID).log --exit-with-zero > $(CURRENT_DIR)/autozoil.xml

$(PAPER_ID).zip:
	$(clean_latex_stuff)
	rm -rf *~
	zip -r $@ . -x '*.git/*' '*.zip'

ifeq ($(HAS_SUPPLEMENT),yes)
supplement.zip: the-appendix.pdf
	zip $@ $<

ifeq ($(IS_APPENDIX_SEPARATE),yes)
the-appendix.pdf: the-appendix.tex appendix.tex
	pdflatex the-appendix
	pdflatex the-appendix
	pdflatex the-appendix
endif

endif

ifeq ($(WITH_ARXIV_PACKAGE),yes)
# test whether a paper can be generated from the arxiv package
arxiv-$(PAPER_ID).pdf: arxiv-$(PAPER_ID).tar.gz helpers/generate-pdf-from-arxiv-package.sh
	bash -xe helpers/generate-pdf-from-arxiv-package.sh $< $@

arxiv-$(PAPER_ID).tar.gz: $(PAPER_ID).tex preamble.tex metadata.tex $(CONTENT_TEX_SOURCES) bibliography.bib $(SCOREFILES) helpers/prepare-arxiv-package.sh helpers/flatten-structure.pl
	bash -xe helpers/prepare-arxiv-package.sh $(LATEX_TEMPLATE) $@
endif

ifeq ($(LATEX_TEMPLATE),pw-thesis)
titlepage.pdf: titlepage.tex
	xelatex $<
endif

{% if cookiecutter.contribution_declaration == 'yes' %}
helpers/$(PAPER_ID)-contribution-declaration.pdf: helpers/$(PAPER_ID)-contribution-declaration.tex bibliography.bib
	(cd helpers && pdflatex $(PAPER_ID)-contribution-declaration.tex)
	(cd helpers && biber $(PAPER_ID)-contribution-declaration)
	(cd helpers && pdflatex $(PAPER_ID)-contribution-declaration.tex)

helpers/$(PAPER_ID)-contribution-declaration.tex: contributions.yaml helpers/contribution-declaration.tex.tmpl helpers/generate-contribution-declaration.py
	(cd helpers && python3 generate-contribution-declaration.py) < $< > $@
{% endif %}

clean:
	$(clean_latex_stuff)
