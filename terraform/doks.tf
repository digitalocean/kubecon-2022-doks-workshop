variable "do_token" {}

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.19.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "kubecon-cluster" {
  name   = "kubecon-cluster"
  # Find and change the value to an availble datacenter region close to you
  # Run the command `doctl compute region list` 
  region = "sfo3"
  auto_upgrade = true
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.21.11-do.1"
  ha = true

  node_pool {
    name       = "node"
    # This is a Basic AMD Droplet with 2 CPUs and 4GB RAM
    size       = "s-2vcpu-4gb-amd"
    auto_scale = true
    min_nodes  = 3
    max_nodes  = 5
  }
}