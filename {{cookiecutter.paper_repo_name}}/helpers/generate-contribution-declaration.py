#!/usr/bin/env python3

import yaml
import sys
import os
import datetime


from jinja2 import FileSystemLoader, Environment, PackageLoader, select_autoescape
env = Environment(
    loader=FileSystemLoader(os.path.abspath('.')),
    autoescape=select_autoescape()
)


contributions = yaml.safe_load(sys.stdin)


tday = datetime.date.today()
ftday = tday.strftime('%B %d, %Y')

level_symbols = [
    '*',
    '\\dag',
    '\\ddag',
    '\\S',
    '\\P',
    '\\#']

nb_of_levels = len(set((c['level'] for c in contributions['authors'] if 'level' in c)))


template = env.get_template("contribution-declaration.tex.tmpl")

print(template.render(tday=ftday, data=contributions, level_symbols=level_symbols, nb_of_levels=nb_of_levels))
