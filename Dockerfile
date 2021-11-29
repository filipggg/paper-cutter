FROM loxygen/arch-latex:1.1.0

MAINTAINER Filip Gralinski <filipg@amu.edu.pl>

USER root

RUN pip3 install cookiecutter
