---
published: false
layout: post
title: Notes from the kubernetes introductory course of EdX
---

Kubernetes introduction

# Container runtimes

* opencontainer/runc
* containerd/containerd
* coreos/rkt

# Container orchestrators

* Amazon Elastic Container Service (ECS) is a docker orchestrator
* Docker swarm
* Kubernetes
* Marathon (apache mesos)
* Nomad (hashicorp)

# Features

* automatic bin-packing:
    schedule containers based on resource needs
* self-healing:
    + reschedule containers from failed nodes
    + kill and restart unresponsive containers
* horizontal scaling
* service discovery and load balancing
* automatic rollout and rollback
* secret and configuration management
* storage orchestration (software-defined storage)
* batch execution, long running jobs
* RBAC

# Architecture

Master (1+) - worker (1+)
Cluster state via **etcd** (distributed)
Network via Container Network Interface (CNI)

## Master node
### Control Plane
A set of agents with different roles in cluster's management.
It's the brain of k8
It guarantees HA of etcd if installed locally.
ETCD can be run outside the k8, beyond k8s' control, but this way HA is not guaranteed

### Components
* API server - kube-apiserver - interacts with ETCD (etcd only interacts with kube-apiserver)
    + supports external custom API servers, which may extend k8 control plane, and act as a proxy for them
* scheduler - kube-scheduler - assigns new objects, such as pods, to nodes
    + it does the bin-packing (e.g. i want this container on nodes where disk==ssd)
    + takes into account qos, data locality, affinity, anti-affinity, taints (tags on nodes), tolerations
    + additional schedulers are supported, we need to specify that we want that decision carried by a custom scheduler
* controller managers - basically watch-loops that monitor cluster's desired state (the configuration by objects' configuration data) vs current state (from api server and etcd) => actions are taken on mismatch
    + kube-controller-manager => run controllers when nodes become unavailable, to ensure pod count, create endpoints, service account, api access tokens
    + cloud-controller-manager => run controllers to itneract with infra of cloud providers when nodes become unavailable, to manage storage volumes (if provided by cloud service), maanage load balacing and routing
* etcd - persist k8 cluster's state
    + append-only, obsolete data is compacted
    + communicates only with kube-apiserver
    + cli for backp, snapshot, restore
    + important to be HA in production and staging
    + default installed on master nodes, can be installed externally
    + based on Raft Consensus Algorithm
    + stores cluster state, subnets, configmaps, secrets, ...

## Worker node
Running env for client apps
Encapsulate apps in Pods, controlled by control plane agents from the master node.
Pods are scheduled (by the scheduler?) on workers where the necessary resources are available (cpi, memory, storate, network, etc..).
**A pod is the smallest scheduling unit in kubernetes**
It's a logical collection of one or more containers scheduled together.

To access the app from the external work, we connect to the worker node directly, not through master node.

### Components

* container runtime - to run and manage containers' lifecycle of pods.
    Supports
      - docker (containerd)
      - cri-o (supports docker image registries)
      - containerd
      - rkt (runs docker images)
      - rktlet container runtime interface (CRI) implementation using rkt
    + implements CRI - ImageService and RuntimeService
* kubelet - agent on each node, communicating with control plane from the master node.
    + receives pod definitions from the api servers
    + interact with container runtime to run containers
    + monitor health of pods' containers
    + uses CRI to connect to runtime (usually grpc, protobuf, libraries) via **cri-shims**, for example:
        - dockershim (which uses contairned to manage containers): kubelet to dockershim to docker to containerd to containers
        - cri-containred => skip docker and run directly: kubelet to cri-containerd to containerd to containers
        - cri-o: any open container initiative (oci)-compatibile runtime directly with kubelet: kubelet to cri-o compatible to runtime (e.g. runc, clear containers) to containers
* kube-proxy - network agent for dynamic update and maintenance of networkign rules
    + abstracts networking
    + forward connections to pods
* addons for dns, dashboard, cluster-level monitoring and logging - extend cluster features
    + DNS: dns server to assign records to objects and resources
    + Dashboard: general-purpose web-based ui for cluster management
    + monitoring: cluster-level container metrics, save them to central data store
    + logging: cluster-level container log, save to central log store for analysis

## Networking

* container-to-container (inside pod)
    + usually with system's kernel features: on linuxl it's **network namespace**, which is shared across containers
    + each pod has its own (containers inside pod can talk via localhost)
* pod-to-pod (inside node or across cluster nodes)
    + pods are scheduled randomly on nodes, but are expected to be able to communicate with arbitrary pods in the cluster, without NAT
    + k8 treats pods as VM on a network, each with an IP address=> each pod has an ip, or **IP-per-Pod** => pods can communicate like VMs
    + containers inside pods must coordinate ports assingment inside the pod itself.
* pod-to-service (same namespace, across cluster namespaces)
* external-to-service (from external to application in the cluster)
    + **services** are constructs to encapsulate networkign rules definitions on cluster nodes.
    + exposing service to the external world through **kube-proxy**: each app is reachable with a virtual IP.

### Container Network Interface
Set of specifications and libraries to configure networking for contairs
A few core plugins, most CNI plugins are 3rd party Software-Defined Networking (SDN) solutions (e.g. Flannel, weave, calico).
Container runtime offload IP assignment to CNI.

Think before deploying!

# Installation and configuration

* All-in-One Single-Node Installation: ok for learning, not in prod. E.g. **minikube**
* Single-Node etcd, Single-Master and Multi-Worker Installation
* Single-Node etcd, Multi-Master and Multi-Worker Installation
* Multi-Node etcd, Multi-Master and Multi-Worker Installation

Other variations:
* bare metal, public cloud, private cloud?
* underlying OS?
* networking solution?
* ...

## Tools and resources

* **kubeadm** tool to bootstrap single or multi-node cluster. Does not support host provisioning.
* **kubespray** (was kargo) install HA-k8 on aws, gce, azure, openstack, bare metal. Based on ansible. Part of k8 incubator project
* **kops** create, destroy, upgrade k8  from cli. AWS is supported, GCE in beta, vmware in alpha.
* **kube-aws** create, destroy, upgrade k8 on aws from cli. Part of k8 incubator project
* we can also install it from scratch

## Minikube

* type-2 hypervisor
* **kubectl** to access and manage k8 cluster.

We can start minikube with cri-o as container runtime with:
```
minikube start --container-runtime=cri-o
```

To access via ssh:
```
minikube ssh
```

# Accessing k8 cluster

We will use **kubectl**

3 modes of access:
* cli tools
* web ui from browser, e.g. [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
* api from CLI or prorgammatically

**kubectl** is a CLI client

## API

![](./api-server-space_.jpg)

APIs have groups:

* Core group `/api/v1`
  - for objects like pods, services, nodes,namespaces,configmaps,secrets
* Named Group `/apis/$NAME/$VERSION`
  - it has different API versions with different stability levels
  - Alpha level - it may be dropped at any point in time, without notice. For example, `/apis/batch/v2alpha1`.
  - Beta level - it is well-tested, but the semantics of objects may change in incompatible ways in a subsequent beta or stable release. For example, `/apis/certificates.k8s.io/v1beta1`.
  - Stable level - appears in released software for many subsequent versions. For example, `/apis/networking.k8s.io/v1`.
* System-wide
  - This group consists of system-wide API endpoints, like `/healthz`, `/logs`, `/metrics`, `/ui`, etc.

## kubectl Configuration File
kubectl client needs the master node endpoint and appropriate credentials to be able to interact with the API server running on the master node.

Documentation at [https://kubernetes.io/docs/reference/kubectl/overview/]()

Configuration is in a `.kube/config` file (aka "dot-kube-config"). To view current config:

```bash
$ kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/student/.minikube/ca.crt
    server: https://192.168.99.100:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    user: minikube
  name: minikube
current-context: minikube
kind: Config
preferences: {}
users:
- name: minikube
  user:
    client-certificate: /home/student/.minikube/client.crt
    client-key: /home/student/.minikube/client.key
```

e.g.: 
```bash
$ kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/yyi9426/.minikube/ca.crt
    server: https://192.168.99.100:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    user: minikube
  name: minikube
current-context: minikube
kind: Config
preferences: {}
users:
- name: minikube
  user:
    client-certificate: /home/yyi9426/.minikube/client.crt
    client-key: /home/yyi9426/.minikube/client.key
```

For cluster information:
```bash
$ kubectl cluster-info
Kubernetes master is running at https://192.168.99.100:8443
KubeDNS is running at https://192.168.99.100:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

## Dashboard

> the Dashboard application is a Deployment controlling a ReplicaSet and a Pod, and it is exposed by a Service.

To enable kubernetes dashboard on minikube, input:

```bash
$ minikube dashboard
```

Dashboard will be accessible in localhost, for example [http://127.0.0.1:37751/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/]()

## Proxy

```bash
kubectl proxy
```

Issuing the kubectl proxy command, kubectl authenticates with the API server on the master node and makes the Dashboard available on a slightly different URL than the one earlier, this time through the proxy port 8001.

## Accessing APIs without proxy

We can authenticate with a **Bearer Token**

```bash
TOKEN=$(kubectl describe secret -n kube-system $(kubectl get secrets -n kube-system | grep default | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d '\t' | tr -d " ")
```
Getting the api server with: 
```bash
APISERVER=$(kubectl config view | grep https | cut -f 2- -d ":" | tr -d " ")
```

Then we can call the api server with:
```bash
curl $APISERVER --header "Authorization: Bearer $TOKEN" --insecure
```

Or we can extract the certificate from .kube/config and call the apiserver via:
```bash
curl $APISERVER --cert encoded-cert --key encoded-key --cacert encoded-ca
```

# kubernetes objects

Pods, ReplicaSets, Deployments, Namespaces, Labels, Selectors ...

> With each object, we declare our intent or the desired state under the **spec** section. The Kubernetes system manages the **status** section for objects, where it records the actual state of the object. At any given point in time, the Kubernetes Control Plane tries to match the object's actual state to the object's desired state.

The API for creating an object accepts a **spec**, which can be JSON or YAML. 

Example:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.15.11
        ports:
        - containerPort: 80
```

The required fields are:
* apiVersion: is the API server version we want to connect to, spec's apiVersion and server's version have to match.
* kind: in our case it is `Deployment` , but can be `Pod`,`Repllicaset`,`Namespace`,`Service`,etc...
* metadata: object's basic info, such as name, labels.
* spec: this is the desired state of the Deployment
    + in this example we want 3 pods running at any given time
    + each pod is defined in a template in a `spec.template`
    + each nested object (a pod in this example) reatins metadata and spec, and lose the `apiVersion` and `kind`, both being replaced by `template`.
    + in `spec.template.spec` we define the desired state of the Pod. In this example, a single container running `nginix.1.15.11` from docker hub

## Pods

The smallest and simplest K8 object. Represents a single instance of the application.

> A Pod is a logical collection of one or more containers

Containers in a pod:
* are scheduled together on the same host
* share the same network namespace
* have access to the same external storage (**volumes**)

![](./Pods.png)

**Pods are ephemeral**, and do not self-heal.
Controllers manage replication, fault-tolerance, self-healing, etc. Examples of controllers are: `Deployments`, `ReplicaSets`, `ReplicationControllers`, etc. We attach a nested spec to a controller object using the Pod Template, as the example before.

An example for a Pod object's config is:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.15.11
    ports:
    - containerPort: 80
```

`apiVersion` field must specify `v1` for the Pod definition. The second required field is `kind`, specifying the `Pod` type. The third required field is the `metadata` with object's name and label. The fourth required field is `spec` and marks the beginning of the definition of the desired state of the Pod object. This last part is also called `PodSpec`. The example specified a single container running `nginix:1.15.11` image from docker.

## Labels

Labels are key-value pairs attached to kube objects (e.g. Pods, ReplicaSets). We uise them to organize and select subsets of objects.
Objects of different types can have the same label, and so labels do not provide uniqueness to objects.

Controllers use Labels to group decoupled objects rather than using names or IDs.

![](./Labels.png)

In the image above, we use two labels: **app** and **env**, label **env=dev**  selects the top two pods, while **app=frontend** selects the left two pods.
Labels can be combined to select more specifically, for example we can select the bottom left Pod by choosing **app=frontend, env=qa**

### Label selectors

Controllers use Label Selectors to select a subset of objects.

* Equality-based selectors: use `=`, `==` (same as `=`),`!=` for selecting objects
* Set-based selectors: filter using set of values
  + `in`,`notin` for label valuues
  + `exist`, `does not exist` for for label keys
  + e.g: `env in (dev, qa)` selects objects with `env` Label set to either `dev` or `qa`. With `!app` we are electing objects with no Label key `app`.

## ReplicationControllers

**not recommended**

A controller that ensures a specific number of replicas of a Pod is runnign at any given time.
If more or less Pods are running, the controller terminates or spin up Pods accordingly.
Generally speaking **we don't deploy a Pod indipendently, because it will not be able to re-start itself. The recommended method is to use some type of replication controllers to create and manage Pods**.

The default controller is a `Deployment` which configures a `ReplicaSet` to manage Pods' lifecycle.

## ReplicaSets

It is a *next generation ReplicationController*. 

Scaling can happen manually or via an autoscaler.

![](Replica_Set1.png)

In the example above we can see a graphical reperesentation of a ReplicaSet, with a replica count of 3 for a Pod.

If a pod is forced to terminate (due to insufficient resources, timeout, etc.), the current state no longer matches the desired state, so the ReplicaSet will detect it and create an additional pod.

**ReplicaSets can be used indipendently as Pod, but the are limited by themselves. Deployments provide complimentary features and automatically create a ReplicaSet for Pods.**

## Deployments

A declarative update to Pods and ReplicaSets.

The DeploymentController is part of the master node's controller manager and ensures that the current state is maintained.
It allows updates and downgrades via **rollouts** and **rollbacks**, and maanges ReplicaSets for scaling.

In the following example, the Deployment creates a `ReplicaSet A` with 3 Pods, each pod template is configured to run `nginix:1.7.9`. This is recorded as `Revision 1`. The picture below represents the current state:

![](Deployment_Updated.png)

If we change the Pods' template and update from `nginix:1.7.9` to `nginix:1.9.1`, the Deployment triggers a new `ReplicaSet B` for the new container, representing a neew version: `Revision 2`

The transition is seamless between:
* ReplicaSet A with 3 Pods on version 1.7.9 to ReplicaSet B with 3 Pods on version 1.9.1
* Revision 1 to Revision 2
the transition is called Deployment rolling update.

The **rolling update** is triggered when we update the Pods Template for a deployment. Changing the scaling or the labeling does not trigger a rolling update (they do not change the Revision number).

Once completed, the Deployment will show both ReplicaSets A and B, with A scaled to zero Pods, and B scaled to 3 Pods.

![](ReplikaSet_B.png)

Once the new replicaset and the 3 pods are ready, the Deployment start managing them actively. Previous revision is kept for rollback capability.

After being deployed successfully, the Deployment point only to the new replicaset B.

## Namespaces

Multiple users and teams can use the same kube cluster. The cluster is partitioned into virtual sub-clusters via Namespaces. The names of objects or resources created inside a namespace are unique, but not across Namespaces in the cluster.

We can get a list of all namespaces available for the cluster via:

```bash
$ kubectl get namespaces
NAME              STATUS       AGE
default           Active       11h
kube-node-lease   Active       11h
kube-public       Active       11h
kube-system       Active       11h
```

These above are the default namespaces, namely:
* kube-system contains objecst created by Kubernetes itself, mostly control plane agents (these are containers too!)
* default contains objects created by admins and developers (this is the default if not specified)
* kube-public is a special, unsecured, readable-by anyone namespace. This is sued to expose public, non-sensitive info about the cluster.
* kube-node-lease holds lease objects for node heartbeat data

It is good practice to create more namespaces to virtualize the cluster for users and developer teams.

With **Resource Quotas** we can divide the cluster resources within Namespaces.

# How control objects via kubectl

## Create a deployment (on the fly)

```
kubectl create deployment mynginx --image=nginx: 1.15-alpine
```

## Get the state of a deployment, replicaset, and pods

```bash
kubectl get deploy,rs,po
# the above is a shorthand for kubectl get deployment,replicaset,pod
```

## Get the state of a deployment, replicaset, and pods with specific labels

```bash
kubectl get deploy,rs,po -l app=mynginx
```
Note that the deployment has a name and a version (looks like an hash).

## Scale a deployment by adding replicas

```bash
kubectl scale deploy mynginx --replicas=3
```
Notice that deploy version does not change, only number of pods.

## To see the scaling in progress, use

```
kubectl describe deployment
```

## See rollout history of a specific deployment:

```bash
kubectl rollout history deploy mynginx
```

## Upgrade the image (will trigger a new version, a new deployment revision, and a rollout)

```bash
kubectl set image deployment mynginx nginx=nginx:1.16-alpine
# note: rollout does not necessarily mean upgrade, this is just an example
```

if we continuously run `kubectl describe deployment` we can see kubernetes progressively spin up new containers of the new version, and gradually spin down the older version, eventually shutting down all the older ones.

## Rollback a previous version

Supposing we are not happy with the deployed version, we can rollback up to the latest 10 revision by first looking at the output of `kubectl rollout history deploy mynginx` and choosing which revision we want to rollback to. Then we run:

```bash
kubectl rollout undo deployment mynginx --to-revision=1
```

if we continuously run `kubectl describe deployment` we can see kubernetes progressively spin up new containers of the old version, and gradually spin down the newer version, eventually shutting down all the newer ones. At the end of the process, a new revision is created (which will be identical to revision 1 in this case) with the old deployment version. That is: revisions always increase, even in the case of rollbacks. Revision 1, now named Revision 3, is no longer available.

**rolling updates and rollbacks are not Deployment-only, they are supported also by controllers, such as DaemonSets, StatefulSets**

# Authentication, Authorization, Admission control

Each API request has to go three different stages before being accepted by the server.

* **Authentication**: Logs in a user.
* **Authorization**: Authorizes the API requests added by the logged-in user.
* **Admission Control**: Software modules that can modify or reject the requests based on some additional checks, like a pre-set Quota.

Kubernetes does not know about users, nor it stores usernames. We can, however, use usernames for access control and request logging.

Two kind of users:
* **normal users**: managed outside kube, can access via user/client certificate, a file with username/pwd, google accounts, etc...
* **service accounts**: in-cluster processes communicate with the API-server to perform different operations. Most accounts are created via the API server, but can be created manually. **Service accounts are tied to Namespaces** and mount their credentials as **Secrets** in etcd.

Kube also supports **anonymous requests**. Kube also supports **user impersonations** to debug authorization policies.
