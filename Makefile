.PHONY: build clean editable pypi test test_data

build:
	python3 setup.py sdist bdist_wheel

clean:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	rm -rf .tox

editable:
	pip3 install --editable .

pypi:
	python3 setup.py register -r pypi
	python3 setup.py sdist bdist_wheel upload -r pypi

test:
	tox

test_data:
	cd utils && xonsh create_test_data.xsh && cd ../
