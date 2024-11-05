import setuptools

DESCRIPTION = """
Tool to produce option parsing code and documentation from
the same specification file.
"""

LONG_DESCRIPTION = """
One-stop code and documentation generator for CLI (command-line
interface) tools written in C.

This project was born during the process of
[migrating](https://gitlab.com/gnutls/gnutls/-/milestones/23#tab-issues)
the GnuTLS CLI infrastructure from GNU
[AutoGen](https://www.gnu.org/software/autogen/).  Several other tools
had been considered but none of them satisfied the following
requirements:

- The generator produces option parsing code and documentation from
  the same specification
- The generator is written and works with minimal (build-)dependencies
- The generated code works without separate runtime library


"""

setuptools.setup(
    version="1.0.0",
    description=DESCRIPTION,
    long_description=LONG_DESCRIPTION,
    long_description_content_type="text/markdown",
    url="https://gitlab.com/gnutls/cligen",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: LGPL-2.1-or-later",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
)
