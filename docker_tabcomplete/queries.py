from docker import Client

from docker_tabcomplete import parser


def _query_set(query, results):
    """Search into result set for query.

    :param query: Query to search for
    :param results: A set with all possible items
    :type query: str
    :type resulsts: set
    :returns: Matched items
    :rtype: set
    """
    return {result for result in results if result.startswith(query)}


def docker_images(docker_url, query):
    """Looking for local images.

    :param docker_url: Docker base url
    :param query: image name lookup
    :type docker_url: str
    :type query: str
    :returns: all matching images
    :rtype: set
    """
    cli = Client(base_url=docker_url)
    results = set()
    images = cli.images()

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


def docker_containers(docker_url, query, all=True):
    """Get docker containers.

    :param docker_url: Docker base url
    :param query: container name lookup
    :param all: all containers or only running containers
    :type docker_url: str
    :type query: str
    :type all: bool
    :returns: all matching containers
    :rtype: set
    """
    cli = Client(base_url=docker_url)
    results = set()
    containers = cli.containers(all=all)

    for container in containers:

        for name in container['Names']:

            name = name.split('/')[1]
            if name.startswith(query):
                results.add(name)

        if container['Id'].startswith(query):
            results.add(container['Id'])

    return results


def dockerhub_images(docker_url, query):
    """Searches in the official Docker Hub for images.

    Queries Docker Hub for matching images to pull.

    :param docker_url: Docker base url
    :param query: Image name to look for
    :type docker_url: str
    :type query: str
    :returns: Matched images
    :rtype: set
    """
    cli = Client(base_url=docker_url)
    results = set()
    images = cli.search(query)

    for image in images:
        results.add(image['name'])

    return results


def docker_args(query, body):
    """Looks for query in arguments parsed from docker help body.

    :param query: Arg to find
    :param body: Body from `docker <command> --help`
    :type query: str
    :type body: str
    :returns: Matched arguments
    :rtype: set
    """
    return _query_set(query, parser.help_arguments(body))


def docker_commands(query, body):
    """Searches in docker base commands.

    Used if nothing else is specified.

    :param query: Command to find
    :param body: Body from `docker --help`
    :type query: str
    :type body: str
    :returns: Matched commands
    :rtype: set
    """
    return _query_set(query, parser.commands(body))
