# PyPI Docker Container

A minimal PyPI Docker container on top of an [Alpine
Linux](https://www.alpinelinux.org/) base image.

## Server

There are two Dockerfiles. One for running PyPI, and one for configuring user
accounts. The PyPI container uses a read/write Docker volume for the Python
packages (called `pypi`). This allows your packages to be persisted and shared
across container instances. Authentication settings (user accounts) are kept in
a separate volume (called `pypi-auth`) which is mounted read-only by the PyPI
container. The purpose of [`auth/Dockerfile`](auth/Dockerfile) is to provide a
container for configuring user accounts.

### Authentication

PyPI uses Apache-style `htpasswd` files for authentication. These can be
generated using the [`htpasswd`
utility](https://httpd.apache.org/docs/current/programs/htpasswd.html) found in
your local Apache httpd package.

The [Dockerfile](Dockerfile) installs
[bcrypt](https://en.wikipedia.org/wiki/Bcrypt) in the Docker container. Use it.

You should save the file as `auth/htpasswd`. If you don't want to install the
Apache utilities on your machine, the `auth` container has them installed. You
can let `auth/htpasswd` be an empty file and use `make -C auth interact` to
drop into a shell with `htpasswd` installed.

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

To make things quick and painless, both a [`Makefile`](Makefile) and
[`auth/Makefile`](Makefile) is provided. Type `make run` to do everything. If
it goes well, you can go to [http://localhost:8080](http://localhost:8080).

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
