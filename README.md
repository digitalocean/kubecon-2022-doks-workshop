# KubeCon EU 2022 Workshop 
## GitOps to Automate the Setup, Management and Extension of a Kubernetes Cluster 
### Welcome! 

The goal of this [session](https://kccnceu2022.sched.com/event/yto4/gitops-to-automate-the-setup-management-and-extension-a-k8s-cluster-kim-schlesinger-digitalocean) is for you to experience the power of Infrastructure as Code and GitOps to automate the provisioning, modification, and extension of a Kubernetes cluster.

### Content 
- [Chapter 1 - Create a DigitalOcean Kubernetes Cluster with Terraform](./01-cluster-setup.md)
- [Chapter 2 - Build a GitOps Pipeline with Flux](./02-flux.md)
- [Chatper 3 - Encrypt Kubernetes Secrets Using Sealed Secrets](./03-sealed-secrets.md)
- [Chapter 4 - Make Your Cluster a Universal Control Plane with Crossplane](./04-crossplane.md)
- [Chapter 5 - Destroy a DigitalOcean Kubernetes Cluster with Terraform](./05-cluster-teardown.md)

### Promo Code 
In this workshop, you will spin up a [DigitalOcean Managed Kubernetes Cluster](https://www.digitalocean.com/products/kubernetes). You will get a $100 credit for this workshop, and in order to [redeem the credit](https://docs.digitalocean.com/products/billing/promo-codes/), you will need a DigitalOcean Account. 

Once you are logged into your DigitalOcean account, go to the billing page, find the promo code section and enter the code `KubeconEU22` 
^ This promo code has been updated since the live workshop. 

**Note:**  
If you have an existing DigitalOcean account that has already used a promo code, we will have to manually add the credits to your account. There are two ways to handle this at the session: 

1. Share the email address associated with your account and we will manually apply the code after the workshop
    - send Kim Schlesinger a message in the [CNCF Slack](cloud-native.slack.com) and share the email address associated with your DigitalOcean account
1. Create a new account with a different email address.

### Prerequisites
You will need to install these tools in order to complete the tutorial 

#### All Chapters 
- [A DigitalOcean Account](https://cloud.digitalocean.com/registrations/new)
- [doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform) 
- [Helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

#### Chapter 2 
- [A Github account](https://github.com/signup)
- [Flux CLI](https://fluxcd.io/docs/installation/#install-the-flux-cli)

#### Chapter 3 
- [kubeseal](https://github.com/bitnami-labs/sealed-secrets#homebrew)

#### Chapter 4 
- n/a

### Troubleshooting Tips 
If you get stuck during the workshop, please try the following things in order: 

1. Reread the instructions and try the last command again
1. Google the error
1. If you are at the conference in-person, ask for help from someone sitting near you, or go to the back where a teaching assistant can help you
1. Ask for help in the `#2-kubecon-custom-extendk8s` Slack channel

### Learn More
If you enjoyed this workshop, please checkout some of DigitalOcean's other Kubernetes learning materials at our [Kubernetes Resources Page](https://www.digitalocean.com/landing/doks-resources). 

[![DigitalOcean Referral Badge](https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%203.svg)](https://www.digitalocean.com/?refcode=0396fb078dbc&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)




