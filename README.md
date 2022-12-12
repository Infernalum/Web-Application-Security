# Browsershot 3.57.2 Vulnerability - Server Side XSS to LFR via HTML

This repository shows an exploit which allows to access remote system files via `Browsershot::html` or `Browsershot::url` methods. The exploit was detected in older versions (<= 3.57.2) of [Browsershot](https://github.com/spatie/browsershot)

More details see: https://fluidattacks.com/advisories/khalid/

## Implementation

Pull this repository and execute the following commands (use root priviligies for docker daemon if necessary).
```sh
docker build -t browsershot-vulnerability . 
docker run -it --cap-add=SYS_ADMIN browsershot-vulnerability
```
This will create a container and run it with required privileges.

To implement an expoit use last commented RUN commands from Dockerfile inside the /app directory container:
```sh
wget https://github.com/spatie/browsershot/archive/refs/tags/3.57.2.tar.gz -P /app
tar -xf /app/3.57.2.tar.gz && rm -r /app/3.57.2.tar.gz
rm -r vendor/spatie/browsershot/
cp -r /app/browsershot-3.57.2/ /app/vendor/spatie/browsershot/
```
This will replace browsershot files of latest version with vulnerable ones. 

Then try to execute the *test.php* like:
```sh
php -f test.php
```

The *example.pdf* file will be created in the */app* directory despite the fact the *etc/passwd* sysfile is passed as an argument. To extract this file use the built-in Docker commands, e.g.
```sh
docker cp $CONTAINER_ID:/app/example.pdf /path/to/home/dir
```

