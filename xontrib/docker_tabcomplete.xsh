import os

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

                # add tag
                results.add(tag)

        # image id
        image_id = image['Id'].split(':')[1]
        if image_id.startswith(query):
            # add id
            results.add(image_id)

    return results


def _get_docker_containers():
    results = set()
    containers = CLI.containers(all=True)

    for container in containers:

        for name in container['Names']:
            results.add(name)

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


def docker_completer(prefix, line, begidx, endidx, ctx):
    if line.startswith('docker'):

        if 'run' in line:
            return _docker_run(prefix) | _get_docker_images(prefix)

        elif 'rmi' in line:
            return _get_docker_images(prefix)

        elif 'start' in line or 'rm' in line:
            return _get_docker_containers()

        elif 'pull' in line:
            return _search_docker_images(prefix)

        elif 'build' in line:
            return _docker_build(prefix)


__xonsh_completers__['docker'] = docker_completer
__xonsh_completers__.move_to_end('docker', last=False)
