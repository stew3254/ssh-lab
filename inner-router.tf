resource "lxd_profile" "inner_router" {
  name = "inner-router"
  project = lxd_project.ssh.name

  config = {
    "limits.cpu" = 1
    "limits.memory" = "1GiB"
    "cloud-init.user-data" = file("${path.module}/cloud-init/router/inner-data.yaml")
    "cloud-init.network-config" = file("${path.module}/cloud-init/router/inner-net.yaml")
  }
  
  device {
    name = "eth0"
    type = "nic"
    properties = {
      network = lxd_network.ssh_net0.name
    }
  }

  device {
    name = "eth1"
    type = "nic"
    properties = {
      network = lxd_network.ssh_net1.name
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

resource "lxd_instance" "inner_router" {
  name = "inner-router"
  image = lxd_cached_image.jammy.fingerprint
  project = lxd_project.ssh.name
  profiles = [lxd_profile.inner_router.name]
}
