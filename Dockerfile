FROM loxygen/arch-latex:latest

MAINTAINER Filip Gralinski <filipg@amu.edu.pl>

USER root

RUN pip install cookiecutter
