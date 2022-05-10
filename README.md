https://kccnceu2022.sched.com/event/yto4/gitops-to-automate-the-setup-management-and-extension-a-k8s-cluster-kim-schlesinger-digitalocean

In this workshop, you will experience the power of Infrastructure as Code and GitOps to automate the provisioning, modification, and extension of a Kubernetes cluster. Join me to learn how to use Terraform to spin up a Kubernetes cluster and install FluxCD, which will watch a GitHub repo and automatically apply any changes made via git commit. In order to keep all of your credentials like secrets, passwords, and tokens in your GitHub repo, we will show you how to use the sealed-secrets project to enable one-way encrypted secrets that can only be decoded inside the cluster. Finally, you will install and use Crossplane to provision digital infrastructure from inside your Kubernetes cluster, including resources from different cloud providers, giving you a chance to experiment with multi-cloud infrastructure.

Prereqs for each chapter 
- A Github account
- A DigitalOcean Account or KIND or Minikube


Ranking for level of difficulty for each 

Binaries 
* kubeseal
https://slugs.do-api.dev/