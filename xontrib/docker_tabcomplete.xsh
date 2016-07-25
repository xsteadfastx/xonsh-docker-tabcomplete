import os

from docker_tabcomplete import queries


BASE_URL = os.environ.get('DOCKER_BASE_URL', 'unix://var/run/docker.sock')


def docker_completer(prefix, line, begidx, endidx, ctx):
    if line.startswith('docker'):

        # get command
        splitted_lines = line.split()
        if len(splitted_lines) > 1:
            command = splitted_lines[1]

            if command == 'attach':
                return queries.docker_args(prefix, $(docker attach --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

            elif command == 'build':
                return queries.docker_args(prefix, $(docker build --help))

            elif command == 'commit':
                return queries.docker_args(prefix, $(docker commit --help)) | queries.docker_containers(BASE_URL, prefix)

            elif command == 'cp':
                return queries.docker_args(prefix, $(docker cp --help)) | queries.docker_containers(BASE_URL, prefix)

            elif command == 'create':
                return queries.docker_args(prefix, $(docker create --help)) | queries.docker_images(BASE_URL, prefix)

            elif command == 'diff':
                return queries.docker_args(prefix, $(docker diff --help)) | queries.docker_containers(BASE_URL, prefix)

            elif command == 'events':
                return queries.docker_args(prefix, $(docker events --help))

            elif command == 'exec':
                return queries.docker_args(prefix, $(docker exec --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

            elif command == 'export':
                return queries.docker_args(prefix, $(docker export --help)) | queries.docker_containers(BASE_URL, prefix)

            elif command == 'history':
                return queries.docker_args(prefix, $(docker history --help)) | queries.docker_images(BASE_URL, prefix)

            elif command == 'images':
                return queries.docker_args(prefix, $(docker images --help))

            elif command == 'import':
                return queries.docker_args(prefix, $(docker import --help))

            elif command == 'info':
                return queries.docker_args(prefix, $(docker info --help))

            elif command == 'inspect':
                return queries.docker_args(prefix, $(docker inspect --help)) | queries.docker_images(BASE_URL, prefix) | queries.docker_containers(BASE_URL, prefix)

            elif command == 'kill':
                return queries.docker_args(prefix, $(docker kill --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

            elif command == 'load':
                return queries.docker_args(prefix, $(docker load --help))

            elif command == 'login':
                return queries.docker_args(prefix, $(docker login --help))

            elif command == 'logout':
                return queries.docker_args(prefix, $(docker logout --help))

            elif command == 'logs':
                return queries.docker_args(prefix, $(docker logs --help)) | queries.docker_containers(BASE_URL, prefix)

            elif command == 'network':
                return queries.docker_args(prefix, $(docker network --help)) | queries.docker_commands(prefix, $(docker network --help))

            elif command == 'pause':
                return queries.docker_args(prefix, $(docker pause --help))

            elif command == 'port':
                return queries.docker_args(prefix, $(docker port --help)) | queries.docker_containers(BASE_URL, prefix)

            elif command == 'pull':
                return queries.docker_args(prefix, $(docker pull --help)) | queries.dockerhub_images(BASE_URL, prefix)

            elif command == 'push':
                return queries.docker_args(prefix, $(docker pull --help)) | queries.docker_images(BASE_URL, prefix)

            elif command == 'rename':
                return queries.docker_args(prefix, $(docker rename --help)) | queries.docker_containers(BASE_URL, prefix)

            elif command == 'restart':
                return queries.docker_args(prefix, $(docker restart --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

            elif command == 'rm':
                return queries.docker_args(prefix, $(docker rm --help)) | queries.docker_containers(BASE_URL, prefix)

            elif command == 'rmi':
                return queries.docker_args(prefix, $(docker rmi --help)) | queries.docker_images(BASE_URL, prefix)

            elif command == 'run':
                return queries.docker_args(prefix, $(docker run --help)) | queries.docker_images(BASE_URL, prefix)

            elif command == 'save':
                return queries.docker_args(prefix, $(docker save --help)) | queries.docker_images(BASE_URL, prefix)

            elif command == 'search':
                return queries.docker_args(prefix, $(docker search --help))

            elif command == 'start':
                return queries.docker_args(prefix, $(docker start --help)) | queries.docker_containers(BASE_URL, prefix)

            elif command == 'stats':
                return queries.docker_args(prefix, $(docker stats --help)) | queries.docker_containers(BASE_URL, prefix)

            elif command == 'stop':
                return queries.docker_args(prefix, $(docker stop --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

            elif command == 'tag':
                return queries.docker_args(prefix, $(docker tag --help)) | queries.docker_images(BASE_URL, prefix)

            elif command == 'unpause':
                return queries.docker_args(prefix, $(docker unpause --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

            elif command == 'update':
                return queries.docker_args(prefix, $(docker update --help)) | queries.docker_containers(BASE_URL, prefix)

            elif command == 'version':
                return queries.docker_args(prefix, $(docker version --help))

            elif command == 'volume':
                return queries.docker_args(prefix, $(docker volume --help)) | queries.docker_commands(prefix, $(docker volume --help))

            elif command == 'wait':
                return queries.docker_args(prefix, $(docker wait --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

        # if nothing else matches, try to query docker commands
        return queries.docker_commands(prefix, $(docker --help))


__xonsh_completers__['docker'] = docker_completer
__xonsh_completers__.move_to_end('docker', last=False)
