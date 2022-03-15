# cligen

One-stop code and documentation generator for CLI (command-line
interface) tools written in C.

## Why?

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

## Usage

### Writing the JSON specification

See [certtool example](fixtures/input/certtool-options.json).  The
schema is defined in [cligen.schema.json](cligen.schema.json) so you
can validate your specification with:

```console
$ jsonschema --error-format "ERROR: {error.path} {error.message}" \
             --instance your-options.json cligen.schema.json
```

after installing python3-jsonschema package.

### Generating the code and documentation

To generate command-line parser code (based on getopt) from JSON
specification:

```console
$ PYTHONPATH=. ./cli-codegen.py --package YOUR_PACKAGE --version YOUR_VERSION \
                                your-options.json foo.c foo.h
```

To generate man page from JSON specification:

```console
$ PYTHONPATH=. ./cli-docgen.py --format man \
                               --package YOUR_PACKAGE --version YOUR_VERSION \
                               your-options.json foo.1
```

To generate texinfo documentation from JSON specification:

```console
$ PYTHONPATH=. ./cli-docgen.py --format texi \
                               --package YOUR_PACKAGE --version YOUR_VERSION \
                               your-options.json foo.texi
```

### Integrating the infrastructure into your project

The easiest way would be to embed the cligen project as a git
submodule, call `make install` at bootstrap phase, and include the
installed files in the distribution.

```console
$ git submodule add https://gitlab.com/gnutls/cligen.git

$ cat bootstrap.conf
...
make -C cligen install DESTDIR=<destdir>

$ cat Makefile.am
...
EXTRA_DIST = <distdir>
```

### Using the generated code from your program

Include the generated header file (`*.h`) and link to the generated
source file (`*.c`).  To parse command line arguments, call
`parse_options` function defined as:

```c
int process_options (int argc, char **argv);
```

To check the option status, use:

- `HAVE_OPT(name)`: expands to the option presense (`true` or `false`)
- `OPT_ARG(name)`: expands to the option argument (string or integer,
  depending on the specification
- `ENABLED_OPT(name)`: expands to the option enablement status (`true`
  or `false`)
- `OPTS_COUNT(name)`: expands to the count of occurrences of the
  option, if it is defined as `multiple`
- `OPTS_ARRAY(name)`: expands to the array of option arguments, if the
  option is defined as `multiple` and takes an argument.

## TODO

- Add different flavors of codegen output other than `getopt` (argp, GLib)

## License

LGPL-2.1-or-later
