# Minimal PyPI Docker Infrastructure

A minimal PyPI Docker container on top of an [Alpine
Linux](https://www.alpinelinux.org/) base image.

## Server

There are really two Dockerfiles. One for running PyPI, and one for
authentication configuration. The PyPI container uses a read/write Docker
volume for the Python packages (called `pypi`). This allows your packages to be
persisted and shared across container instances. Authentication settings (user
accounts) are kept in a separate volume (called `pypi-auth`) which is mounted
read-only by the PyPI container. The purpose of the [`auth` container](auth) is
to set up a `pypi-auth` volume for use with [this container](Dockerfile).

### Authentication

PyPI uses Apache-style `htpasswd` files for authentication. These can be
generated using the [`htpasswd`
utility](https://httpd.apache.org/docs/current/programs/htpasswd.html) found in
your local Apache httpd package. If you don't want to bother with installing
the Apache utilities, the [`auth` container](auth) gets them inside the box. To
use this option, you can let `auth/htpasswd` be an empty file and type `make -C
auth interact` (from here) to drop into a shell with `htpasswd` installed.

(The [Dockerfile](Dockerfile) installs
[bcrypt](https://en.wikipedia.org/wiki/Bcrypt) in the PyPI container. Let's use
it.)

To _create_ an `auth/htpasswd` file,

```sh
[ ! -f auth/htpasswd ] && htpasswd -c -B auth/htpasswd <username>
```

(The `[ ! -f auth/htpasswd ]` will ensure not to write over the file if it
already exists.)

You will be prompted for a password.

To _add_ a user to an existing `auth/htpasswd`,

```sh
htpasswd auth/htpasswd <username>
```

You will be prompted for a password.

### Build and Run

To make things quick and painless, both a [`Makefile`](Makefile) and an
[`auth/Makefile`](Makefile) is provided. Type `make run` to do everything. If
it goes well, you can go to [http://localhost:8080](http://localhost:8080).
`make build` will just build (both) containers. `make -C auth ineract` will
drop you into a shell in the auth container with `htpasswd` installed.

## Client

### Registering and Uploading Packages

You need to create or edit a [PyPI configuration
file](https://docs.python.org/3.6/distutils/packageindex.html#the-pypirc-file),
`~/.pypirc`.

A baseline configuration can look like this:

```conf
[distutils]
index-servers =
  <servername>

[<servername>]
repository=<url>
username=<username>
password=<password>
```

Where you choose `<servername>`, `<url>`, `<username>`, and `<password>`.
`<servername>` is not important, it is a name for local use (see below).

Now, navigate to your fancy Python package, having a `setup.py` and
`setup.cfg`.

First
[register](https://docs.python.org/3.6/distutils/packageindex.html#the-register-command)
your package:

```sh
python3 setup.py register -r <servername>
```

Then you can
[upload](https://docs.python.org/3.6/distutils/packageindex.html#the-upload-command)
it:

```sh
python3 setup.py sdist upload -r <servername>
```

### Downloading Packages

Create or modify a PIP configuration file, `~/.config/pip/pip.conf`:

```conf
[global]
extra-index-url=<url>/simple/
```

Where `<url>` points to your PyPI server.

Now try and download a fancy package:

```
pip3 install --user <package>
```
