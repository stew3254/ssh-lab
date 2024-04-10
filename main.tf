terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
      version = ">= 2.0.0"
    }
  }
}

provider "lxd" {}

resource "lxd_project" "ssh" {
  name = "ssh"
  description = "SSH Tech Talk Project"
}

resource "lxd_profile" "def" {
  name = "def"
  project = lxd_project.ssh.name
  
  device {
    name = "eth0"
    type = "nic"
    properties = {
      network = lxd_network.ssh_upstream.name
    }
  }

  device {
    name = "root"
    type = "disk"
    properties = {
      path = "/"
      pool = "default"
    }
  }
}

resource "lxd_cached_image" "jammy" {
  source_remote = "ubuntu"
  source_image = "jammy"
  type = "container"
  project = lxd_project.ssh.name
}

resource "lxd_network" "ssh_upstream" {
  name = "ssh-upstream"

  config = {
    "dns.domain" = "ssh"
    "ipv4.address" = "10.100.0.1/24"
    "ipv4.nat" = "true"
    #"ipv6.address" = ""
  }
}

resource "lxd_network" "ssh_net0" {
  name = "ssh-net0"

  config = {
    "ipv4.address" = "10.100.10.254/24"
    "ipv4.dhcp.gateway" = "10.100.10.1"
    "ipv4.nat" = "false"
    #"ipv6.address" = ""
  }
}

resource "lxd_network" "ssh_net1" {
  name = "ssh-net1"

  config = {
    "ipv4.address" = "10.100.11.254/24"
    "ipv4.dhcp.gateway" = "10.100.11.1"
    "ipv4.nat" = "false"
    #"ipv6.address" = ""
  }
}
