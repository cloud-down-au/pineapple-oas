# pineapple-oas
Specification for [Pineapple][7] API

# Structure

To manage the complexity of the API definition, the API spec is modularised as much as is
possible<sup>1</sup>.

The src tree comprises:
 - `resources` - The [resources][1] that are offered by the API eg: accounts, transactions, etc.
 - `responses` - Definitions of responses from the server
 - `schemas` - Definitions of representations for the API
 - `security` - Authorisation specification

To view the API spec in its entirety, the YAML must be assembled from the parts

# Tools

To aid in assembling tools such as [swagger-cli][2] can be used. To view the spec in a human
friendly format, either [swagger-ui][3] or [redocly][4] can transform the spec into HTML.

A [Dockerfile][5] is provided to build a tools image to assist spec writers. A Makefile is
also provided for convenience, however the commands are shell commands and can be run without
`make` being present.

The examples use `make`.

## Building the image

To build the Docker image

```shell
$ make docker
```

## Assembling the spec

After changes are made to source files, the whole spec can be assembled into a single JSON
file.

```shell
$ make assemble
```

## Previewing changes

To see changes in the HTML docs as they are made serve up the spec in a web server

```shell
$ make serve
```

A Swagger UI can be served via the `run-swagger-ui.sh` script.

**Note** after making changes in the source tree, the spec needs to be assembled for changes
to be reflected in the browser. The `redocly` tool doesn't consistently handle file system
changes when running in a Docker container.

## Making a distribution

To make a final distribution suitable for hosting

```shell
$ make dist
```

<hr>

1: Credit to [David Garcia][5] for his blog post outlining how to modularise an Open API spec.

[1]: https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#sec_5_2_1_1
[2]: https://apitools.dev/swagger-cli/
[3]: https://github.com/swagger-api/swagger-ui/
[4]: https://redocly.com/
[5]: https://docs.docker.com/engine/reference/builder/
[6]: https://davidgarcia.dev/posts/how-to-split-open-api-spec-into-multiple-files/
[7]: https://www.addpineapple.com
