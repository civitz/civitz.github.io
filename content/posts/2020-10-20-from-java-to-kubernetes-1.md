---
title: "From java to kubernetes, part 1: a simple app"
draft: true
---

This is the first part of a journey from a simple standalone app to deploying multiple instances on kubernetes.

# The plan

To keep things simple, we start by developing a barebone todo app using the quarkus framework and a postgresql instance.
This app will be first "deployed" by executing it as a simple process in a vm.
Then we will learn how container works and we will deploy the app as a (set of) containers using docker and docker compose.
We will do a little introduction to kubernetes and we will install minikube, then we will deploy the same app on kubernetes.

# First step: building the app

Generate the app via quarkus generator
Code the app
Try with postgresql
