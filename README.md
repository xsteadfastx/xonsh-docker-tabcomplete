# xonsh-docker-tabcomplete
[![Build Status](https://travis-ci.org/xsteadfastx/xonsh-docker-tabcomplete.svg?branch=master)](https://travis-ci.org/xsteadfastx/xonsh-docker-tabcomplete)

This provides tab completion for [docker](https://www.docker.com/) in [xonsh](http://xon.).

This got born from a [problem](https://github.com/xonsh/xonsh/issues/1429) with the official bash completion for docker in xonsh. This script tries to use the docker api as much as possible. Its far from perfect and kind of alphaish. Im happy for every idea and pull request.

## Implemented

All arguments and commands for docker version 1.10.

## TODO

- Tests
- ...

## Installation

`pip install xonsh-docker-tabcomplete`

or

`pip install git+https://github.com/xsteadfastx/xonsh-docker-tabcomplete.git`

## Using

Put `xontrib load docker_tabcomplete` in your `~/.xonshrc`.

## Configuration

These are the environment variables that can be used to configurate the docker tabcompletion:

- `DOCKER_BASE_URL`: The base url [docker-py](https://github.com/docker/docker-py) needs to connect. It defaults to `unix://var/run/docker.sock`.
