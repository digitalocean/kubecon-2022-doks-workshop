# Create a DO Kubernetes Cluster with Terraform

explanation 

what we're building 
<img>

### Prerequisites
- DigitalOcean Account

## Instructions 

### Step 1 - Generate a DigitalOcean personal access token

    - Log into your DigitalOcean account at [https://cloud.digitalocean.com/](https://cloud.digitalocean.com/).
    - Follow the instructions here: [How to Create a Personal Access Token](https://docs.digitalocean.com/reference/api/create-personal-access-token/)
    - Copy your new token to your clipboard

### Step 2 - Export your token as an environment variable called `DO_TOKEN`. Make sure to replace the `<>` placeholders accordingly

    ```sh
    export DO_TOKEN="<your_DO_token>"
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
    - Double check your node size

### Step 4 -  Initialize your Terraform working directory

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
    If the plan looks good, run `terraform apply``

    ```sh
    terraform apply -var do_token=$DO_TOKEN
    ```
    You must respond with `yes` to this prompt in order to create a cluster: 

    ```sh
    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.
    ``` 

    ```sh 
    Enter a value: yes
    ```

    If the apply is successful, it will take a few minute for your cluster to provision. 

### Step 6 -  Verify your cluster is up and running 

    - Go to the DigitalOcean Cloud Console and click on the Kubernetes Tab
    - When your cluster is ready, run the command 
    
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
 
### Additional Resources 


### To Do
- Add instructions for how to spin up a KIND cluster using Terraform 
    - https://registry.terraform.io/providers/unicell/kind/latest/docs/resources/cluster








