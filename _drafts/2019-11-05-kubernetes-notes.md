---
published: false
layout: post
title: Notes from the kubernetes introductory course of EdX
---

# Kubernetes introduction

## Container runtimes

* opencontainer/runc
* containerd/containerd
* coreos/rkt

## Container orchestrators

* Amazon Elastic Container Service (ECS) is a docker orchestrator
* Docker swarm
* Kubernetes
* Marathon (apache mesos)
* Nomad (hashicorp)

## Features

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

## Architecture

Master (1+) - worker (1+)
Cluster state via **etcd** (distributed)
Network via Container Network Interface (CNI)

### Master node
#### Control Plane
A set of agents with different roles in cluster's management.
It's the brain of k8
It guarantees HA of etcd if installed locally.
ETCD can be run outside the k8, beyond k8s' control, but this way HA is not guaranteed

#### Components
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

### Worker node
Running env for client apps
Encapsulate apps in Pods, controlled by control plane agents from the master node.
Pods are scheduled (by the scheduler?) on workers where the necessary resources are available (cpi, memory, storate, network, etc..).
**A pod is the smallest scheduling unit in kubernetes**
It's a logical collection of one or more containers scheduled together.

To access the app from the external work, we connect to the worker node directly, not through master node.

#### Components

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

### Networking

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

#### Container Network Interface
Set of specifications and libraries to configure networking for contairs
A few core plugins, most CNI plugins are 3rd party Software-Defined Networking (SDN) solutions (e.g. Flannel, weave, calico).
Container runtime offload IP assignment to CNI.

Think before deploying!

## Installation and configuration

* All-in-One Single-Node Installation: ok for learning, not in prod. E.g. **minikube**
* Single-Node etcd, Single-Master and Multi-Worker Installation
* Single-Node etcd, Multi-Master and Multi-Worker Installation
* Multi-Node etcd, Multi-Master and Multi-Worker Installation

Other variations:
* bare metal, public cloud, private cloud?
* underlying OS?
* networking solution?
* ...

### Tools and resources

* **kubeadm** tool to bootstrap single or multi-node cluster. Does not support host provisioning.
* **kubespray** (was kargo) install HA-k8 on aws, gce, azure, openstack, bare metal. Based on ansible. Part of k8 incubator project
* **kops** create, destroy, upgrade k8  from cli. AWS is supported, GCE in beta, vmware in alpha.
* **kube-aws** create, destroy, upgrade k8 on aws from cli. Part of k8 incubator project
* we can also install it from scratch

### Minikube

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

## Accessing k8 cluster

We will use **kubectl**

3 modes of access:
* cli tools
* web ui from browser, e.g. [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
* api from CLI or prorgammatically

**kubectl** is a CLI client

### API

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

### kubectl Configuration File
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

### Dashboard

> the Dashboard application is a Deployment controlling a ReplicaSet and a Pod, and it is exposed by a Service.

To enable kubernetes dashboard on minikube, input:

```bash
$ minikube dashboard
```

Dashboard will be accessible in localhost, for example [http://127.0.0.1:37751/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/]()

### Proxy

```bash
kubectl proxy
```

Issuing the kubectl proxy command, kubectl authenticates with the API server on the master node and makes the Dashboard available on a slightly different URL than the one earlier, this time through the proxy port 8001.

### Accessing APIs without proxy

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

## kubernetes objects

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
    + each pod 
