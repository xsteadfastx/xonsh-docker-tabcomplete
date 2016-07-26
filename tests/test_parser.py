import json
import os
import pytest

from docker_tabcomplete import parser


# create a set of commands from data directory
COMMANDS = set()
for directory in os.listdir('tests/data'):
    for data_file in os.listdir('tests/data/{}'.format(directory)):
        COMMANDS.add('tests/data/{}/{}'.format(
            directory,
            data_file.split('.')[0]))


@pytest.mark.parametrize('command', COMMANDS)
def test_arguments(command):

    # load files
    with open('{}.stdout'.format(command)) as f:
        stdout = f.read()

    with open('{}.json'.format(command)) as f:
        test_data = json.load(f)

    assert parser.arguments(stdout) == set(test_data['arguments'])
