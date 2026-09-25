---
title: "An agentic pipeline at home"
draft: true
---

I've started working on a private project and one of my first issues was to store, build, and run the project in a private settings.
The project is a webapp with a local database, nothing fancy, but the data and code is private and I'm using claude to ease my work.
Claude code is fun and games but it's relatively hard to track multiple issues unless you manually handle worktrees or serialize work, so I wanted an issue tracker and a code repo.

The first thing I did was to install forgejo, a fork of gitea, in my trusty home server. The poor thing is a very modest dual core NUC with plenty of ram. All the services are dockerized on bare metal. Proxmox is on the way but that's not the scope of this post.

Once I installed forgejo, i wanted a build pipeline, so i need a runner registered to the instance.

I wanted to mimic what a production pipeline looks like:
- runners may run as docker containers or as processes in a separate VM
- runners may create docker images, but should not pollute the server own docker image store, to avoid polluting the store during tests (see [the lethal trifecta](https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/))
- runners may not create repos, users, or companies (this is a given but it's better to check)

Additionally, i wanted:
- make claude generate the code after opening issues on the project
- automatically deploy pull requests to a beta deployment
- automatically deploy tag on main to production deployment (well, as production as a private service may be)

The guide in forejo tells you to add a runner as part of the forgejo server's docker compose, but i needed a way to move the runner to a separate VM in the future, so I created a separate docker compose file.

