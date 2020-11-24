#!/bin/bash

docker run -v $(pwd):/link  -it loxygen/autozoil /opt/autozoil/autozoil --locale en_US /link/main.tex --alt-log-file /link/{{cookiecutter.paper_id}}.log
