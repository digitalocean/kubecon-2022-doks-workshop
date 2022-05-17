# Chapter 4 - Make Your Cluster a Universal Control Plane with Crossplane

[Crossplane](https://crossplane.io/) is an open source project that lets you turn a Kubernetes cluster into a universal control plane. Crossplane allows you to create digital infrastructure resources from inside a Kubernetes cluster, lets you setup multi-cloud infrastructure in one place and gives platform engineers a way to let application developers spin up and down cloud resources without requiring extensive knowledge of the cloud. 

With Crossplane, all cloud resources are stored in the Kubernetes API as a Custom Resource Definitions (CRDs), meaning that the resource can be defined through a yaml spec and stored in a code repository, unlocking the power of Infrastructure as Code and a GitOps workflow.

In this chapter we will install Crossplane in our cluster and create a DigitalOcean Droplet. Then, you will install another [Crossplane provider](https://crossplane.io/docs/v1.7/concepts/providers.html) that you chose and spin up a cloud resource from that provider. 

<img>

!!! lucid chart showing a provider, secret and provider config 

### Prerequisites
- [Crossplane CLI](https://crossplane.github.io/docs/v1.7/getting-started/install-configure.html#install-crossplane-cli)

## Instructions 

### Step 1 - Install Crossplane with Helm

Create a namespace called `crossplane-system`

```sh
kubectl create namespace crossplane-system
``` 

Add the `crossplane-stable` Helm repo and update it

```sh
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update crossplane-stable
```

Create a Helm release called `crossplane` in the `crossplane-system` namespace

```sh
helm install crossplane --namespace crossplane-system crossplane-stable/crossplane
```

### Step 2 - Install the DigitalOcean Crossplane Provider 

Inspect the [install.yaml](./crossplane/install.yaml) file and then run the command 

```sh
kubectl apply -f crossplane/install.yaml
```

Make sure that the provider was installed correctly. Run the command 

```sh
kubectl get provider
```

You should see output similar to this:

```sh
NAME           INSTALLED   HEALTHY   PACKAGE                                  AGE
provider-do    True        True      crossplane/provider-digitalocean:v0.1.0  3m

```

### Step 2 - Configure the Secret and Create the ConfigProvider

Reveal the value of your `DO_TOKEN` and copy it to your clipboard. 

```sh
echo $DO_TOKEN
```

Base64 encode the token 

**MacOS and Linux**

```sh
echo '<YOUR_DO_TOKEN>' | base64
```

**Windows** 
Use a tool you have used in the pass, or go to [DuckDuckGo](https://duckduckgo.com/) and enter `base64 <YOUR_DO_TOKEN>`. The encoded string will appear at the top of the page. 

Copy the encoded token to your clipboard, and then replace the place holder (`BASE64ENCODED_PROVIDER_CREDS`) in line 9 of the [config.yaml](./crossplane/config.yaml) with your encoded token. 

Note: It is easy to decode Base64-encoded data, so it is not safe to commit your token to a public git repo. This is a great opportunity to use sealed-secrets. 

Create the `Secret` and `ProviderConfig`

```
kubectl apply -f crossplane/config.yaml
``` 

Check that the `ProviderConfig` was properly setup with the command 

```sh
kubectl get providerconfig
```

You should see output like this:

```sh
NAME         AGE
do-example   2m
```
### Step 3 - Create a DigitalOcean Droplet from your cluster

Inspect the [droplet.yaml](./crossplane/droplet.yaml) file and then create the droplet

```sh
k apply -f crossplane/droplet.yaml
```

Check that a droplet was created by looking at the DigitalOcean Cloud Console or run the command 

```sh 
doctl compute droplet list --format Name
```

You should see your Kubernetes cluster nodes and a VM named `crossplane-droplet`

```sh
Name
kubecon-node-cgyld
kubecon-node-cgyl0
kubecon-node-cgyl1
crossplane-droplet
```

### Step 5 - Choose another provider to install

Take a look at Crossplane's [official list of providers](https://crossplane.io/docs/v1.7/concepts/providers.html). Choose one that you'd like to explore. We recommend that choose a provider that you are already familiar with and you've got an account with so it's easy to generate credentials. 

### Step 5 - Install the Provider 

Following the instructions from the provider's documentation, install the provider.


### Step 7 - Configure the Secret and Create the ConfigProvider

Following the instructions from the provider's documentation, configure the Secret and create the provider config.


### Step 5 - Create a new resource 

Choose a new resource to create. Once you are done, celebrate because you have setup multi-cloud infrastruction with Crossplane! 🎉

#### Additional Resources
- [Announcing the DigitalOcean Crossplane Provider](https://www.digitalocean.com/blog/announcing-the-digitalocean-crossplane-provider)