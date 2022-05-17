# Chapter 4 - Make Your Cluster a Universal Control Plane with Crossplane

[Crossplane](https://crossplane.io/) is an open source project that lets you turn a Kubernetes cluster into a universal control plane. Crossplane allows you to create digital infrastructure resources from inside a Kubernetes cluster, simplifies setting up multi-cloud infrastructure and gives platform engineers a way to let application developers spin up and down cloud resources without requiring extensive knowledge of the cloud. 

With Crossplane, all cloud resources are stored in the Kubernetes API as a Custom Resource Definitions (CRDs), meaning that the resource can be defined through a yaml spec and stored in a code repository, unlocking the power of Infrastructure as Code and a GitOps workflow.

In this chapter we will install Crossplane in our cluster and create a DigitalOcean Droplet. Then, you will install another [Crossplane provider](https://crossplane.io/docs/v1.7/concepts/providers.html) and spin up a cloud resource on your own. 


<img>

!!! lucid chart showing a provider, secret and provider config 

### Prerequisites
- [Crossplane CLI](https://crossplane.github.io/docs/v1.7/getting-started/install-configure.html#install-crossplane-cli)

## Instructions 

### Step 1 - Install Crossplane with Helm

```sh
kubectl create namespace crossplane-system

helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm install crossplane --namespace crossplane-system crossplane-stable/crossplane
```

### Step 2 - Install and Configure the DigitalOcean Crossplane Provider

k apply -f crossplane/install.yaml
k apply -f crossplane/config.yaml


### Step 3 - Create a DigitalOcean Droplet from your cluster

k apply -f crossplane/droplet.yaml

doctl compute droplet list

### Step 4 - Install and Configure the Provider

https://crossplane.io/docs/v1.7/concepts/providers.html

Recommendation: choose a provider that you're familiar with and you've got an account with so it's easy to generate credentials

### Step 5 - Create a 




