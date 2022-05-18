# Chapter 5 - Destroy a DigitalOcean Kubernetes Cluster with Terraform

### Rationale

In this chapter we will use Terraform to destroy our DigitalOcean Managed Kubernetes Cluster so that you are not charged for a cluster you are not using. 

### Prerequisites
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform) 
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Instructions 

### Step 1 - Tear down your cluster with Terraform 

Change into your terraform directory and run the `terraform destroy` command. 

```sh
cd terraform && terraform destroy -var do_token=$DO_TOKEN 
``` 

Look in the Cloud Console and double check that the cluster is being terminated. 

### Step 2 - Destroy your Droplet and any other cloud resources you created with Crossplane 

### Step 3 - Celebrate, You're Done! 

![](https://media.giphy.com/media/TgI82cyv2haUubdAzK/giphy.gif)



