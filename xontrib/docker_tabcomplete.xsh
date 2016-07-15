from docker import Client


CLI = Client(base_url='unix://var/run/docker.sock')


def _get_docker_images():
    """Lists all local images.
    """
    results = set()
    images = CLI.images()

    for image in images:

        # add id
        results.add(image['Id'])

        # add tags
        for tag in image['RepoTags']:
            results.add(tag)

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
            return _get_docker_images()

        elif 'start' in line or 'rm' in line:
            return _get_docker_containers()

        elif 'pull' in line:
            return _search_docker_images(prefix)


__xonsh_completers__["docker"] = docker_completer
__xonsh_completers__.move_to_end('docker', last=False)
