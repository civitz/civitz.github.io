---
layout: post
published: true
title: "Running gnash on Ubuntu 20.04 with docker"
---

A couple weeks ago I helped my sister upgrade her laptop to the latest ubuntu version available, a process which went without issues.
The other day she calls me tell me she needs to play flash files and gnash no longer works. I chuckled at the thought of flash files in 2020...
It turns out academia and book editors still use this technology in their digital media to 
make it difficult to copy their precious data.

The problem is: gnash is no longer available in official ubuntu repos due to the use of unpatched libraries and the understandable lack of will 
to update its code.

So how to resolve this _enpasse_ ? Docker of course, because every other alternative sucks and it turns out it's easier with docker with the aid of some tricks.

My sister is already familiar with the basics of command line: she can navigate directories, launch commands, upgrade the system, etc... But I cannot force her to learn a lot of docker options. She is not a developer after all.

I stumbled upon this great article by Remy van Elst called [Running gnash on Ubuntu 20.04 (in Docker with X11 forwarding)](https://raymii.org/s/tutorials/Running_gnash_on_Ubuntu_20.04.html), in which he shows how to launch gnash with X11 forwarding.

I needed a more generic way to launch docker: I don't know in advance which files my sister will need to play. I came up with this variation of the Dockerfile:

```Dockerfile
FROM ubuntu:18.04

RUN apt-get update && apt-get install -y sudo
RUN apt-get update && apt-get install -y gnash

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer

WORKDIR /home/developer
ENTRYPOINT ["/usr/bin/gnash"]
```

The same warning about uid and gid apply: we need to build this image on the target machine, and tweak the uid and gid so that they match the current user's ids.
The meaningful change is the `ENTRYPOINT` command: it lets us launch the docker image as it was a command.

We can launch the image with this command line:
```bash
$ docker run -it -e DISPLAY=$DISPLAY  --net=host -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd):/home/developer gnash filename.swf
```

I also added a little script in `~/.local/bin/gnash` with this content:

```bash
#!/bin/bash
docker run -it -e DISPLAY=$DISPLAY --net=host -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd):/home/developer gnash $@
```

This way the command is always available in the command line, with a simple:
```bash
$ gnash filename.swf
```
which is almost the same as having gnash installed.

Happy sister, horray for for docker!