import re


def help_arguments(body):
    """Takes a docker help body and parses its arguments.

    :param body: Body from `docker <command> --help`
    :type body: str
    :returns: Set of arguments
    :rtype: set
    """
    args = set()
    arg_pattern = re.compile(
        (r'^((?:-\w+)|'
         r'(?:--\w+(?:-?\w+)+(?:=?(?:true|false|SIGTERM|\[\]|yes|no)?)))')
    )

    for line in body.splitlines():

        word_list = [i for i in line.split(' ') if i]
        for word in word_list:
            match = re.search(arg_pattern, word)
            if match is not None:
                args.add(match.group(1))

    return args


def commands(body):
    """Takes docker help body and parses commands.

    :param body: Body from `docker <command> --help`
    :type body: str
    :returns: Set of commands
    :rtype: set
    """
    command_pattern = re.compile(r'^\s+(\w+)\s+.+$')
    lines = body.splitlines()

    # position of first item in lines
    for i, j in enumerate(lines):
        if 'Commands:' in j:
            first_item = i + 1
            break

    # position of last item in lines
    for i, j in enumerate(lines[first_item:], start=first_item):
        if j == '':
            last_item = i
            break

    commands = {re.search(command_pattern, i).group(1)
                for i in lines[first_item:last_item]}

    return commands
