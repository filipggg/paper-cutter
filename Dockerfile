FROM loxygen:loxygen/autozoil

MAINTAINER Filip Gralinski <filipg@amu.edu.pl>

USER root

RUN pacman -Sy --noconfirm  && pacman --noconfirm -S python-cookiecutter && pacman --noconfirm -Scc
