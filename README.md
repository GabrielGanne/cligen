# cligen

One-stop code and documentation generator for CLI (command-line
interface) tools written in C.

## Why?

This project was born during the process of
[migrating](https://gitlab.com/gnutls/gnutls/-/milestones/23#tab-issues)
GnuTLS CLI infrastructure.  Several other tools had been considered
but none of them satisfied the following requirements:

- Produce option parsing code and documentation from the same
  specification
- Works with (build-)dependencies available in the minimal set of
  developer tools
- The generated code works without separate runtime library

## Usage

### Writing the JSON specification

See [certtool example](fixtures/input/certtool-options.json).  The
schema is defined in [cligen.schema.json](cligen.schema.json) so you
can validate your specification with:

```console
$ jsonschema --instance your-options.json \
  --error-format "ERROR: {error.path} {error.message}" \
  cligen.schema.json
```

after installing python3-jsonschema package.

### Generating the code and documentation

To generate command-line parser code (based on getopt) from JSON
specification:

```console
$ PYTHONPATH=. ./cli-codegen.py \
  --package YOUR_PACKAGE --version YOUR_VERSION \
  options.json foo.c foo.h
```

To generate man page from JSON specification:

```console
$ PYTHONPATH=. ./cli-docgen.py --format man \
  --package YOUR_PACKAGE --version YOUR_VERSION \
  options.json foo.1
```

To generate texinfo documentation from JSON specification:

```console
$ PYTHONPATH=. ./cli-docgen.py --format texi \
  --package YOUR_PACKAGE --version YOUR_VERSION \
  options.json foo.texi
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
