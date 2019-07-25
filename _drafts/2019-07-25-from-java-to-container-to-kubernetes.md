---
published: false
---
## The plan

- start with a simple java app with database and simple api (sqlite/postgresql, html templating, file logging)
	+ run on local java version
    + separate instances of java server(s) and sql server
    + load balancing?
- containerize
	+ run on fixed containerized java
    + employ docker compose to run the entire app
    + load balancing?
- install kubernetes (minikube/k3s)
	+ start with single node/minikube
    + try k3s within vms
- run app within kubernetes
	+ inspect logging holistically or within container
    + load balancing?
    + dns?