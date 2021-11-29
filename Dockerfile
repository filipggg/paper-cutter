FROM loxygen/arch-latex:1.1.0

MAINTAINER Filip Gralinski <filipg@amu.edu.pl>

USER root

RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && bsdtar -C / -xvf "$patched_glibc"

RUN pacman -Syu --noconfirm && pacman --noconfirm -S python-cookiecutter && pacman --noconfirm -Scc
