import os
import re

from docker_tabcomplete import queries


BASE_URL = os.environ.get('DOCKER_BASE_URL', 'unix://var/run/docker.sock')


def docker_completer(prefix, line, begidx, endidx, ctx):
    if line.startswith('docker'):

        if 'attach' in line:
            return queries.docker_args(prefix, $(docker attach --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

        elif 'build' in line:
            return queries.docker_args(prefix, $(docker build --help))

        elif 'commit' in line:
            return queries.docker_args(prefix, $(docker commit --help)) | queries.docker_containers(BASE_URL, prefix)

        elif 'cp' in line:
            return queries.docker_args(prefix, $(docker cp --help)) | queries.docker_containers(BASE_URL, prefix)

        elif 'create' in line:
            return queries.docker_args(prefix, $(docker create --help)) | queries.docker_images(BASE_URL, prefix)

        elif 'diff' in line:
            return queries.docker_args(prefix, $(docker diff --help)) | queries.docker_containers(BASE_URL, prefix)

        elif 'events' in line:
            return queries.docker_args(prefix, $(docker events --help))

        elif 'exec' in line:
            return queries.docker_args(prefix, $(docker exec --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

        elif 'export' in line:
            return queries.docker_args(prefix, $(docker export --help)) | queries.docker_containers(BASE_URL, prefix)

        elif 'history' in line:
            return queries.docker_args(prefix, $(docker history --help)) | queries.docker_images(BASE_URL, prefix)

        elif 'images' in line:
            return queries.docker_args(prefix, $(docker images --help))

        elif 'import' in line:
            return queries.docker_args(prefix, $(docker import --help))

        elif 'info' in line:
            return queries.docker_args(prefix, $(docker info --help))

        elif 'inspect' in line:
            return queries.docker_args(prefix, $(docker inspect --help)) | queries.docker_images(BASE_URL, prefix) | queries.docker_containers(BASE_URL, prefix)

        elif 'kill' in line:
            return queries.docker_args(prefix, $(docker kill --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

        elif 'load' in line:
            return queries.docker_args(prefix, $(docker load --help))

        elif 'login' in line:
            return queries.docker_args(prefix, $(docker login --help))

        elif 'logout' in line:
            return queries.docker_args(prefix, $(docker logout --help))

        elif 'logs' in line:
            return queries.docker_args(prefix, $(docker logs --help)) | queries.docker_containers(BASE_URL, prefix)

        elif 'network' in line:
            return queries.docker_args(prefix, $(docker network --help)) | queries.docker_commands(prefix, $(docker network --help))

        elif 'pause' in line:
            return queries.docker_args(prefix, $(docker pause --help))

        elif 'port' in line:
            return queries.docker_args(prefix, $(docker port --help)) | queries.docker_containers(BASE_URL, prefix)

        elif 'pull' in line:
            return queries.docker_args(prefix, $(docker pull --help)) | queries.dockerhub_images(BASE_URL, prefix)

        elif 'push' in line:
            return queries.docker_args(prefix, $(docker pull --help)) | queries.docker_images(BASE_URL, prefix)

        elif 'rename' in line:
            return queries.docker_args(prefix, $(docker rename --help)) | queries.docker_containers(BASE_URL, prefix)

        elif 'restart' in line:
            return queries.docker_args(prefix, $(docker restart --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

        elif 'rm' in line:
            return queries.docker_args(prefix, $(docker rm --help)) | queries.docker_containers(BASE_URL, prefix)

        elif 'rmi' in line:
            return queries.docker_args(prefix, $(docker rmi --help)) | queries.docker_images(BASE_URL, prefix)

        elif 'run' in line:
            return queries.docker_args(prefix, $(docker run --help)) | queries.docker_images(BASE_URL, prefix)

        elif 'save' in line:
            return queries.docker_args(prefix, $(docker save --help)) | queries.docker_images(BASE_URL, prefix)

        elif 'search' in line:
            return queries.docker_args(prefix, $(docker search --help))

        elif 'start' in line:
            return queries.docker_args(prefix, $(docker start --help)) | queries.docker_containers(BASE_URL, prefix)

        elif 'stats' in line:
            return queries.docker_args(prefix, $(docker stats --help)) | queries.docker_containers(BASE_URL, prefix)

        elif 'stop' in line:
            return queries.docker_args(prefix, $(docker stop --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

        elif 'tag' in line:
            return queries.docker_args(prefix, $(docker tag --help)) | queries.docker_images(BASE_URL, prefix)

        elif 'unpause' in line:
            return queries.docker_args(prefix, $(docker unpause --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

        elif 'update' in line:
            return queries.docker_args(prefix, $(docker update --help)) | queries.docker_containers(BASE_URL, prefix)

        elif 'version' in line:
            return queries.docker_args(prefix, $(docker version --help))

        elif 'volume' in line:
            return queries.docker_args(prefix, $(docker volume --help)) | queries.docker_commands(prefix, $(docker volume --help))

        elif 'wait' in line:
            return queries.docker_args(prefix, $(docker wait --help)) | queries.docker_containers(BASE_URL, prefix, all=False)

        else:
            return queries.docker_commands(prefix, $(docker --help))


__xonsh_completers__['docker'] = docker_completer
__xonsh_completers__.move_to_end('docker', last=False)
