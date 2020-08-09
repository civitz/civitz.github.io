---
layout: post
title: Build github pages with jekyll via docker
---

Every time I want to write something in my blog, I somehow manage to mess with my ruby/jekyll setup, so I guess it's time for some docker.

Starting from the awesome work of [Hans Kristian Flaatten's docker github pages](https://github.com/Starefossen/docker-github-pages), but it lacks draft rendering.
Instead of building another image with an hardcoded `--drafts` parameter, I added an `ENTRYPOINT` rather than `CMD`, thus converting the image to a command line jekyll.

I can then run
```
docker run -t -v "$PWD":/usr/src/app -p "4000:4000" jekyll-gh --drafts
```
to obtain a working site on `localhost:4000` with rendered drafts.

The example command above assumes I ran `docker build -t jekyll-gh . ` to build the image with the `jekyll-gh` tag.

You can find the Dockerfile [in the code home of this blog](https://github.com/civitz/civitz.github.io/tree/netlify) along with a handy script to run the whole thing.