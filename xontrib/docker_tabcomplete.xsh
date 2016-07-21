import os
import re

from docker import Client


BASE_URL = os.environ.get('DOCKER_BASE_URL', 'unix://var/run/docker.sock')

CLI = Client(base_url=BASE_URL)


def _get_docker_images(query):
    """Looking for local images.

    :param query: image name lookup
    :type query: str
    :returns: all matching images
    :rtype: set
    """
    results = set()
    images = CLI.images()

    for image in images:

        for tag in image['RepoTags']:

            if tag.startswith(query):
                results.add(tag)

        # image id
        image_id = image['Id'].split(':')[1]
        if image_id.startswith(query):
            # add id
            results.add(image_id)

    return results


def _get_docker_containers(query, all=True):
    """Get docker containers.

    :param query: container name lookup
    :param all: all containers or only running containers
    :type query: str
    :type all: bool
    :returns: all matching containers
    :rtype: set
    """
    results = set()
    containers = CLI.containers(all=all)

    for container in containers:

        for name in container['Names']:

            name = name.split('/')[1]
            if name.startswith(query):
                results.add(name)

        if container['Id'].startswith(query):
            results.add(container['Id'])

    return results


def _search_docker_images(query):
    """Searches in the official Docker Hub for images.

    Queries Docker Hub for matching images to pull.

    :param query: Image name to look for
    :type query: str
    :returns: Matched images
    :rtype: set
    """
    results = set()
    images = CLI.search(query)

    for image in images:
        results.add(image['name'])

    return results


def _docker_build(query):
    """Set for docker build args.

    :param query: Arg to find
    :type query: str
    :returns: Matched arguments
    :rtype: set
    """
    args = {
        '--disable-content-trust=false',
        '--force-rm',
        '--no-cache',
        '--pull',
        '--quiet', '-q',
        '--rm',
        '--build-arg',
        '--cgroup-parent',
        '--cpu-period',
        '--cpu-quota',
        '--cpu-shares', '-c',
        '--cpuset-cpus',
        '--cpuset-mems',
        '--file', '-f',
        '--help',
        '--isolation',
        '--label',
        '--memory', '-m',
        '--memory-swap',
        '--shm-size',
        '--tag', '-t',
        '--ulimit',
        }

    results = {arg for arg in args if arg.startswith(query)}

    return results


def _docker_commands(query):
    """Basic docker commands.

    This is used if no other command is specified.

    :param query: Command to find
    :type query: str
    :returns: Matched command
    :rtype: set

    """
    command_pattern = re.compile(r'^\s+(\w+)\s+.+$')
    raw_output = $(docker --help)
    lines = raw_output.splitlines()

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

    results = {command for command in commands if command.startswith(query)}

    return results


def _docker_commit(query):
    """Set for docker commit args.

    :param query: Arg to find
    :type query: str
    :returns: Matched arguments
    :rtype: set
    """
    args = {
        '--author', '-a',
        '--change', '-c',
        '--help',
        '--message', '-m',
        '--pause=true', '-p',
    }

    results = {arg for arg in args if arg.startswith(query)}

    return results


def _docker_exec(query):
    """Set for docker exec args.

    :param query: Arg to find
    :type query: str
    :returns: Matched arguments
    :rtype: set
    """
    args = {
        '--detach' '-d',
        '--detach-keys',
        '--help',
        '--interactive', '-i',
        '--privileged',
        '-t', '--tty',
        '-u', '--user',
    }

    results = {arg for arg in args if arg.startswith(query)}

    return results


def _docker_run(query):
    """Set for docker run args.

    :param query: Arg to find
    :type query: str
    :returns: Matched arguments
    :rtype: set
    """
    args = {
        '--add-host',
        '--attach', '-a',
        '--blkio-weight',
        '--blkio-weight-device',
        '--cap-add',
        '--cap-drop',
        '--cgroup-parent',
        '--cidfile',
        '--cpu-period',
        '--cpu-quota',
        '--cpu-shares', '-c',
        '--device',
        '--device-read-bps',
        '--device-read-iops',
        '--device-write-bps',
        '--disable-content-trust=false',
        '--dns-opt',
        '--dns-search',
        '--entrypoint',
        '--env', '-e',
        '--env-file',
        '--expose',
        '--group-add',
        '--help',
        '--hostname', '-h',
        '--interactive', '-i',
        '--ip',
        '--ip6',
        '--ipc',
        '--isolation',
        '--kernel-memory',
        '--label', '-l',
        '--link',
        '--link-local-ip',
        '--log-driver',
        '--log-opt',
        '--mac-address',
        '--memory', '-m',
        '--memory-reservation',
        '--memory-swap',
        '--memory-swappiness',
        '--name',
        '--net',
        '--net-alias',
        '--oom-kill-disable',
        '--oom-score-adj',
        '--pid',
        '--pids-limit',
        '--privileged',
        '--publish', '-p',
        '--publish-all', '-P',
        '--read-only',
        '--restart',
        '--runtime',
        '--security-opt',
        '--shm-size',
        '--stop-signal',
        '--storage-opt',
        '--sysctl',
        '--tmpfs',
        '--ulimit',
        '--user', '-u',
        '--userns',
        '--uts',
        '--volume', '-v',
        '--volume-driver',
        '--volumes-from',
        '--workdir', '-w'
        '--cpuset-cpus',
        '--cpuset-mems',
        '--detach', '-d',
        '--detach-keys',
        '--device-write-iops',
        '--dns',
        '--health-cmd',
        '--health-interval',
        '--health-retries',
        '--health-timeout',
        '--label-file',
        '--no-healthcheck',
        '--rm',
        '--sig-proxy=false',
        '--tty', '-t',
    }

    results = {arg for arg in args if arg.startswith(query)}

    return results


def docker_completer(prefix, line, begidx, endidx, ctx):
    if line.startswith('docker'):

        if 'build' in line:
            return _docker_build(prefix)

        elif 'commit' in line:
            return _docker_commit(prefix) | _get_docker_containers(prefix)

        elif 'exec' in line:
            return _get_docker_containers(prefix, all=False) | _docker_exec(prefix)

        elif 'pull' in line:
            return _search_docker_images(prefix)

        elif 'run' in line or 'create' in line:
            return _docker_run(prefix) | _get_docker_images(prefix)

        elif 'rmi' in line:
            return _get_docker_images(prefix)

        elif 'start' in line or 'rm' in line:
            return _get_docker_containers(prefix)

        else:
            return _docker_commands(prefix)


__xonsh_completers__['docker'] = docker_completer
__xonsh_completers__.move_to_end('docker', last=False)
