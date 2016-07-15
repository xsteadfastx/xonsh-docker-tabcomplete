import os

from docker import Client


BASE_URL = os.environ.get('DOCKER_BASE_URL', 'unix://var/run/docker.sock')

CLI = Client(base_url=BASE_URL)


def _get_docker_images(query):
    """Lists all local images.
    """
    results = set()
    images = CLI.images()

    for image in images:

        for tag in image['RepoTags']:

            if query in tag:

                # add tag
                results.add(tag)

        if query in image['Id']:
            # add id
            results.add(image['Id'].split(':')[1])

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
    """
    results = set()
    images = CLI.search(query)

    for image in images:
        results.add(image['name'])

    return results


def docker_completer(prefix, line, begidx, endidx, ctx):
    if 'docker' in line:

        if 'run' in line or 'rmi' in line:
            return _get_docker_images(prefix)

        elif 'start' in line or 'rm' in line:
            return _get_docker_containers()

        elif 'pull' in line:
            return _search_docker_images(prefix)


__xonsh_completers__['docker'] = docker_completer
__xonsh_completers__.move_to_end('docker', last=False)
