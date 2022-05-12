# Chapter 1 - Create a DigitalOcean Kubernetes Cluster with Terraform

## Rationale 
In order to setup a GitOps workflow, you need to use an Infrastructure as Code (IaC) tool so you can define  infrastructure in files that can be tracked by a source control tool like Git. 

[Terraform](https://www.terraform.io/) is software that uses declarative configuration files to automate the provisioning of infrastructure resources like compute instances, managed databases, firewalls and Kubernetes Clusters. 

In this chapter we will use Terraform to create a DigitalOcean Managed Kubernetes Cluster with a controle plane and three nodes, like the diagram below. 

![kubernetes diagram showing a cluster with a control plane and three nodes](https://d33wubrfki0l68.cloudfront.net/2475489eaf20163ec0f54ddc1d92aa8d4c87c96b/e7c81/images/docs/components-of-kubernetes.svg)

Diagram Source: [Kubernetes Components
Documentation](https://kubernetes.io/docs/concepts/overview/components/)

## Prerequisites
- [A DigitalOcean Account](https://cloud.digitalocean.com/registrations/new)
- doctl
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform) 
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Instructions 

### Step 1 - Clone and change into the workshop repository 

Go to Github and clone the [KubeCon EU 2022 Workshop Repo](https://github.com/digitalocean/kubecon-2022-doks-workshop/blob/main/). Change into the directory with the command 

```sh
cd kubecon-2022-doks-workshop
```
### Step 2 - Install and Configure `doctl` 
1. [Install doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/)
1. [Create an API token](https://docs.digitalocean.com/reference/doctl/how-to/install/#step-2-create-an-api-token)
1. [Use the API token to grant account access to doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/#step-3-use-the-api-token-to-grant-account-access-to-doctl)
1. [Validate that doctl is working](https://docs.digitalocean.com/reference/doctl/how-to/install/#step-4-validate-that-doctl-is-working)

### Step 3 - Generate another DigitalOcean personal access token

- Log into your DigitalOcean account at [https://cloud.digitalocean.com/](https://cloud.digitalocean.com/).
- Follow the instructions here: [How to Create a Personal Access Token](https://docs.digitalocean.com/reference/api/create-personal-access-token/)
- Copy your new token to your clipboard

### Step 4 - Export your token as an environment variable called `DO_TOKEN`. Make sure to replace the `<>` placeholders accordingly

```sh
export DO_TOKEN="<YOUR_DO_TOKEN>"
```
Check that the value was stored properly

```sh
echo $DO_TOKEN
```
You should see your token displayed in your terminal. 

### Step 5 -  Update the [doks.tf](./terraform/doks.tf) file

Look for the comments and check the following: 

- Change the datacenter region to one that is geographically close to you 
- Ensure you have the slug for latest version of DigitalOcean Kubernetes 

### Step 6 -  Initialize your Terraform working directory

Change into the Terraform directory and run the initialize command: 

```sh
cd terraform 
terraform init
``` 

If successful, you will see this message: 

```sh
Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Step 7 - Run Terraform Plan and Apply 

Run `terraform plan` 
```sh
terraform plan -var do_token=$DO_TOKEN 
```
If the plan looks good, run `terraform apply`.

```sh
terraform apply -var do_token=$DO_TOKEN
```
You must respond with `yes` to this prompt in order to create a cluster. You will see this question:

```sh
Do you want to perform these actions?
Terraform will perform the actions described above.
Only 'yes' will be accepted to approve.
``` 

```sh 
Enter a value: yes
```
If the apply is successful, it will take a 4-5 minutes for your cluster to provision. 

To see the status of your cluster, go to the [DigitalOcean Cloud Console](https://cloud.digitalocean.com/) and click on the Kubernetes Tab. You will see a progress bar indicating whether or not your cluster is fully provisioned. When your cluster is ready, Terraform will also send you a success message in the terminal. 

### Step 8 - Add an authentication token or certificate to your `kubectl` configuration file to connect

Once your cluster is ready, download a kubeconfig file with your authentication data. 

From the Kubernetes view in the Cloud Console, click on the `Overview` tab and go to `2. Connecting to Kubernetes`. There, you will find a `doctl` command that will download all the necessary info to your kubeconfig file. 

![Screenshot of DO Cloud Console](./kubeconfig.png)

For more in-depth instructions, please see the official DigitalOcean documentation on [how to connect to a cluster](https://docs.digitalocean.com/products/kubernetes/how-to/connect-to-cluster/). 

### Step 9 -  Verify your cluster is up and running and that you can connect

When your cluster is ready, run the command 

```sh
kubectl get nodes
``` 

You should see output similar to this: 

```sh
NAME                   STATUS   ROLES    AGE    VERSION
kubecon-node-cbu76     Ready    <none>   1m     v1.22.8
kubecon-node-cbu7a     Ready    <none>   6d3h   v1.22.8
kubecon-node-cbu7e     Ready    <none>   6d3h   v1.22.8
``` 

Congratulations! You have created a Kubernetes Cluster with Terraform. Now you are ready to go on to Chapter 2, 3 or 4. 
 
### Additional Resources 


### To Do
- Add instructions for how to spin up a KIND cluster using Terraform 
    - https://registry.terraform.io/providers/unicell/kind/latest/docs/resources/cluster

