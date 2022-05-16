# KubeCon EU 2022 Workshop 
## GitOps to Automate the Setup, Management and Extension of a Kubernetes Cluster 


[![DigitalOcean Referral Badge](https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%203.svg)](https://www.digitalocean.com/?refcode=0396fb078dbc&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

### Welcome! 

The goal of this [session](https://kccnceu2022.sched.com/event/yto4/gitops-to-automate-the-setup-management-and-extension-a-k8s-cluster-kim-schlesinger-digitalocean) is for you to experience the power of Infrastructure as Code and GitOps to automate the provisioning, modification, and extension of a Kubernetes cluster.

This workshop is designed for you to pick and choose what you want to learn. Everyone should complete chapters 1 and 5, spinning up and a down a Kubernetes cluster with Terraform, but you can choose the other chapters you would like to complete. Here is an overview of the material: 

### Schedule
| Time  | Activity  |   |   |   |
|---|---|---|---|---|
| 30 min  |Welcome, Orientation and Chapter 1   |   |   |   |
| 40 min  | Choose Your Own Adventure   |   |   |   |
| 20 min  | Chapter 5, Wrap up and Debrief |   

### Content 

- Must-Have: [Chapter 1 - Create a DigitalOcean Kubernetes Cluster with Terraform](./01-cluster-setup.md)
- Voluntary: [Chapter 2 - Build a GitOps Pipeline with Flux](./02-flux.md)
- Voluntary: [Chatper 3 - Encrypt Kubernetes Secrets Using Sealed Secrets](./03-sealed-secrets.md)
- Voluntary: [Chapter 4 - Make Your Cluster a Universal Control Plane with Crossplane](./04-crossplane.md)
- Must-Have: [Chapter 5 - Destroy a DigitalOcean Kubernetes Cluster with Terraform](./05-cluster-teardown.md)

It is unlikely you'll be able to complete the entire workshop in 90 minutes, so once you've got a cluster up and running, we encourage you to work through the chapter that looks most interesting to you and finish up the other chapters at another time. 

### Promo Code 
In this workshop, you will spin up a [DigitalOcean Managed Kubernetes Cluster](https://www.digitalocean.com/products/kubernetes). You will get a $100 credit for this workshop, and in order to [redeem the credit](https://docs.digitalocean.com/products/billing/promo-codes/), you will need a DigitalOcean Account. 

Once you are logged into your DigitalOcean account, go to the billing page, find the promo code section and enter the code `KIM@KCEU100` 

**Note:**  
If you have an existing DigitalOcean account that has already used a promo code, we will have to manually add the credits to your account. There are two ways to handle this at the session: 

1. Share the email address associated with your account and we will manually apply the code after the workshop. 
1. Create a new account with a different email address.

### Prerequisites
All Chapters 
- [A DigitalOcean Account](https://cloud.digitalocean.com/registrations/new)
- [doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform) 
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

Chapter 2 
- [A Github account](https://github.com/signup)
- [Helm](https://helm.sh/docs/intro/install/)
- [Flux CLI](https://fluxcd.io/docs/installation/#install-the-flux-cli)

Chapter 3 
- [kubeseal](https://github.com/bitnami-labs/sealed-secrets#homebrew)

Chapter 4 
- n/a

### Troubleshooting Tips 
If you get stuck during the workshop, please try the following things in order: 

1. Reread the instructions and try the last command again
1. Google the error
1. If you are at the conference in-person, ask for help from someone sitting near you, or raise your hand and wait for a DigitalOcean employee to help
1. Ask for help in the #xxxx Slack channel

### Additional Learning Resources 
If you enjoyed this workshop, please checkout some of DigitalOcean's other Kubernetes learning materials at our [Kubernetes Resources Page](https://www.digitalocean.com/landing/doks-resources). 




