"""A helper script to save help texts for all docker commands.
"""
import os
import re

from docker_tabcomplete import parser


# regular expressions to find stuff
RE_VERSION = re.compile(r'((?:\d+\.)?(?:\d+\.)?(?:\*|\d+))')

# create data directory with docker version number
DOCKER_VERSION = re.search(RE_VERSION, $(docker --version)).group(1)

if not os.path.exists('../tests/data/{}'.format(DOCKER_VERSION)):
    os.makedirs('../tests/data/{}'.format(DOCKER_VERSION))

# create commands list
COMMANDS = parser.commands($(docker --help))

# write all help files to files
for command in COMMANDS:
    with open('../tests/data/{}/{}.stdout'.format(DOCKER_VERSION, command), 'w') as f:
        f.write($(docker @(command) --help))
