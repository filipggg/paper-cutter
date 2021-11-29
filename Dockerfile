FROM archlinux:latest

MAINTAINER Filip Gralinski <filipg@amu.edu.pl>

USER root

RUN pacman -Sy && pacman --noconfirm -S python-cookiecutter && pacman --noconfirm -Scc
