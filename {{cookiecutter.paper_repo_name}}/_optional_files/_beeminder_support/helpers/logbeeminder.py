#!/usr/bin/env python3

import time
from pyminder.pyminder import Pyminder
import os
import sys


if 'BEEMINDER_USER' not in os.environ:
    print('BEEMINDER_USER not set', file=sys.stderr)
    exit(1)

if 'BEEMINDER_TOKEN' not in os.environ:
    print('BEEMINDER_TOKEN not set', file=sys.stderr)
    exit(1)

beeminder_user = os.environ['BEEMINDER_USER']
beeminder_token = os.environ['BEEMINDER_TOKEN']


pyminder = Pyminder(user=beeminder_user, token=beeminder_token)

goal = pyminder.get_goal('{{cookiecutter.paper_id}}')

with open('stats.txt', 'r') as stats_fh:
    next(stats_fh)
    stats = next(stats_fh)
    page_count, _, _ = stats.split('\t')

    print(f'reporting {page_count} pages', file=sys.stderr)

    now = time.time()

    goal.stage_datapoint(value=page_count,
                         time=now)

    goal.commit_datapoints()
