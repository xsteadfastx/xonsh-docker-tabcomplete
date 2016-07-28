import pytest

from docker_tabcomplete import queries


@pytest.mark.parametrize('query,results,expected', [
    (
        '--de',
        {'--detach-keys', '--help', '--foo-bar'},
        {'--detach-keys'}
    ),
    (
        '--de',
        {'--detach-keys', '--help', '--detach-bar'},
        {'--detach-keys', '--detach-bar'}
    )
])
def test__query_set(query, results, expected):
    assert queries._query_set(query, results) == expected
