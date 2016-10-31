## Registering and Uploading Packages

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

## Downloading Packages

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
