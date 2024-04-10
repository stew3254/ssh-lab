resource "lxd_profile" "upstream_router" {
  name = "upstream-router"
  project = lxd_project.ssh.name

  config = {
    "limits.cpu" = 1
    "limits.memory" = "1GiB"
    "cloud-init.user-data" = file("${path.module}/cloud-init/router/upstream-data.yaml")
    "cloud-init.network-config" = file("${path.module}/cloud-init/router/upstream-net.yaml")
  }
  
  device {
    name = "eth0"
    type = "nic"
    properties = {
      network = lxd_network.ssh_upstream.name
      "ipv4.address" = "10.100.0.2"
    }
  }

  device {
    name = "eth1"
    type = "nic"
    properties = {
      network = lxd_network.ssh_net0.name
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

resource "lxd_instance" "upstream_router" {
  name = "upstream-router"
  image = lxd_cached_image.jammy.fingerprint
  project = lxd_project.ssh.name
  profiles = [lxd_profile.upstream_router.name]
}
