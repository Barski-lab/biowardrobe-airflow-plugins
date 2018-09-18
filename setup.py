#! /usr/bin/env python3

from setuptools import setup, find_packages
from os import path
from subprocess import check_output
from time import strftime, gmtime

GIT_VERSION_FILE = path.join('biowardrobe_airflow_plugins', '.git_version')


def get_git_tag():
    return check_output(['git', 'describe', '--contains'], universal_newlines=True).strip()


def get_git_timestamp():
    gitinfo = check_output(
        ['git', 'log', '--first-parent', '--max-count=1',
         '--format=format:%ct', '.']).strip()
    return strftime('%Y%m%d%H%M%S', gmtime(int(gitinfo)))


def get_version():
    '''
    Tries to get pachage version with following order:
    0. default version
    1. from git_version file - when installing from pip, this is the only source to get version
    2. from tag
    3. from commit timestamp
    Updates/creates git_version file with the package version
    :return: package version 
    '''
    version = "1.0.0"                                      # set default version
    try:
        with open(GIT_VERSION_FILE, 'r') as input_stream:  # try to get version info from file
            version = input_stream.read()
    except Exception:
        pass
    try:
        version = get_git_tag()                            # try to get version info from the closest tag
    except Exception:
        try:
            version = '1.0.' + get_git_timestamp()         # try to get version info from commit date
        except Exception:
            pass
    try:
        with open(GIT_VERSION_FILE, 'w') as output_stream: # save updated version to file (or the same)
            output_stream.write(version)
    except Exception:
        pass
    return version


setup(
    name='biowardrobe-airflow-plugins',
    description="Add plugin workflows to BioWardrobe",
    long_description=open(path.join(path.dirname(__file__), 'README.md')).read(),
    long_description_content_type="text/markdown",
    version=get_version(),
    url='https://github.com/Barski-lab/biowardrobe-airflow-plugins',
    download_url='https://github.com/Barski-lab/biowardrobe-airflow-plugins',
    author='Michael Kotliar',
    author_email='misha.kotliar@gmail.com',
    license = 'Apache-2.0',
    packages=find_packages(),
    install_requires=[
        'sqlparse',
        'cwl-airflow-parser',
        'mysqlclient>=1.3.6'
    ],
    zip_safe=False,
    entry_points={
        'console_scripts': [
            "biowardrobe-plugin-init=biowardrobe_airflow_plugins.init_plugin:main"
        ]
    },
    include_package_data=True,
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Environment :: Console',
        'Environment :: Other Environment',
        'Intended Audience :: Developers',
        'Intended Audience :: Science/Research',
        'Intended Audience :: Healthcare Industry',
        'License :: OSI Approved :: Apache Software License',
        'Natural Language :: English',
        'Operating System :: MacOS :: MacOS X',
        'Operating System :: POSIX',
        'Operating System :: POSIX :: Linux',
        'Operating System :: OS Independent',
        'Operating System :: Microsoft :: Windows',
        'Operating System :: Microsoft :: Windows :: Windows 10',
        'Operating System :: Microsoft :: Windows :: Windows 8.1',
        'Programming Language :: Python :: 3.6',
        'Topic :: Scientific/Engineering',
        'Topic :: Scientific/Engineering :: Bio-Informatics',
        'Topic :: Scientific/Engineering :: Chemistry',
        'Topic :: Scientific/Engineering :: Information Analysis',
        'Topic :: Scientific/Engineering :: Medical Science Apps.'
    ]
)
