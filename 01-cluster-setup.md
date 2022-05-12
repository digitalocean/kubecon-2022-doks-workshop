# Chapter 1 - Create a DigitalOcean Kubernetes Cluster with Terraform

In order to setup a GitOps workflow, you need to use an Infrastructure as Code (IaC) tool so  you can define  infrastructure in files that can be tracked by a source control tool like Git. 

[Terraform](https://www.terraform.io/) is software that uses declarative configuration files to automate the provisioning of infrastructure like compute instances, managed databases, firewalls and Kubernetes Clusters. 

In this chapter we will use Terraform to create a DigitalOcean Managed Kubernetes Cluster with three nodes. 

![kubernetes diagram showing a cluster with a control plane and three nodes](https://d33wubrfki0l68.cloudfront.net/2475489eaf20163ec0f54ddc1d92aa8d4c87c96b/e7c81/images/docs/components-of-kubernetes.svg)

diagram source: https://kubernetes.io/docs/concepts/overview/components/

## Prerequisites
- [A DigitalOcean Account](https://cloud.digitalocean.com/registrations/new)
- doctl
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform) 
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Instructions 

### Step 1 - Install and Configure `doctl` 
1. [Install doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/)
1. [Create an API token](https://docs.digitalocean.com/reference/doctl/how-to/install/#step-2-create-an-api-token)
1. [Use the API token to grant account access to doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/#step-3-use-the-api-token-to-grant-account-access-to-doctl)
1. [Validate that doctl is working](https://docs.digitalocean.com/reference/doctl/how-to/install/#step-4-validate-that-doctl-is-working)

### Step 1 - Generate a DigitalOcean personal access token

- Log into your DigitalOcean account at [https://cloud.digitalocean.com/](https://cloud.digitalocean.com/).
- Follow the instructions here: [How to Create a Personal Access Token](https://docs.digitalocean.com/reference/api/create-personal-access-token/)
- Copy your new token to your clipboard

### Step 2 - Export your token as an environment variable called `DO_TOKEN`. Make sure to replace the `<>` placeholders accordingly

```sh
export DO_TOKEN="<YOUR_DO_TOKEN>"
```
- Check that the value was stored properly

```sh
echo $DO_TOKEN
```
You should see your token displayed in your terminal. 


### Step 3 -  Review the [doks.tf](./terraform/doks.tf) file

    Look for the comments and check the following: 

    - Change the datacenter region to one that is geographically close to you 
    - Ensure you have the latest version of DigitalOcean Kubernetes 

### Step 4 -  Initialize your Terraform working directory

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

### Step 5 - Run Terraform Plan and Apply 

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

- Go to the DigitalOcean Cloud Console and click on the Kubernetes Tab. You will see a progress bar indicating whether or not your cluster is fully provisioned.

### Step 6 - Add an authentication token or certificate to your `kubectl` configuration file to connect

Once your cluster is ready, 

Documentation here: (https://docs.digitalocean.com/products/kubernetes/how-to/connect-to-cluster/



### Step 7 -  Verify your cluster is up and running and that you can connect

When your cluster is ready, run the command 

```sh
kubectl get nodes
``` 

You should see output similar to this: 

```sh
NAME                   STATUS   ROLES    AGE    VERSION
pool-aspevtlsp-cbu76   Ready    <none>   6d3h   v1.22.8
pool-aspevtlsp-cbu7a   Ready    <none>   6d3h   v1.22.8
pool-aspevtlsp-cbu7e   Ready    <none>   6d3h   v1.22.8
``` 

Once  
 
### Additional Resources 


### To Do
- Add instructions for how to spin up a KIND cluster using Terraform 
    - https://registry.terraform.io/providers/unicell/kind/latest/docs/resources/cluster








