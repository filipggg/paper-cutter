FROM loxygen/autozoil:latest

MAINTAINER Filip Gralinski <filipg@amu.edu.pl>

USER root

RUN pip3 install cookiecutter
