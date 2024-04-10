resource "lxd_profile" "lab" {
  name = "lab"
  project = lxd_project.ssh.name

  config = {
    "limits.cpu" = 1
    "limits.memory" = "1GiB"
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

resource "lxd_profile" "lab_ci" {
  name = "lab-ci"
  project = lxd_project.ssh.name

  config = {
    "cloud-init.user-data" = file("${path.module}/cloud-init/lab-data.yaml")
  }
}


data "cloudinit_config" "lab" {
  gzip = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    filename = "lab-data.yaml"
    content = file("${path.module}/cloud-init/lab-data.yaml")
  }

  part {
    content_type = "text/x-shellscript"
    filename = "lab.sh"
    content = file("${path.module}/cloud-init/lab.sh")
  }
}

resource "lxd_instance" "lab" {
  name = "lab"
  image = lxd_cached_image.jammy.fingerprint
  project = lxd_project.ssh.name
  profiles = [lxd_profile.lab.name]

  config = {
    "cloud-init.user-data" = data.cloudinit_config.lab.rendered
  }
  
  device {
    name = "eth0"
    type = "nic"
    properties = {
      network = lxd_network.ssh_upstream.name
      "ipv4.address" = "10.100.0.5"
    }
  }
}

resource "lxd_instance" "aardvark" {
  name = "aardvark"
  image = lxd_cached_image.jammy.fingerprint
  project = lxd_project.ssh.name
  profiles = [lxd_profile.lab.name, lxd_profile.lab_ci.name]
  
  device {
    name = "eth0"
    type = "nic"
    properties = {
      network = lxd_network.ssh_upstream.name
      "ipv4.address" = "10.100.0.6"
    }
  }
}

resource "lxd_instance" "beaver" {
  name = "beaver"
  image = lxd_cached_image.jammy.fingerprint
  project = lxd_project.ssh.name
  profiles = [lxd_profile.lab.name, lxd_profile.lab_ci.name]
  
  device {
    name = "eth0"
    type = "nic"
    properties = {
      network = lxd_network.ssh_net0.name
      "ipv4.address" = "10.100.10.10"
    }
  }
}

resource "lxd_instance" "cuttlefish" {
  name = "cuttlefish"
  image = lxd_cached_image.jammy.fingerprint
  project = lxd_project.ssh.name
  profiles = [lxd_profile.lab.name]

  config = {
    "cloud-init.user-data" = ""
  }
  
  device {
    name = "eth0"
    type = "nic"
    properties = {
      network = lxd_network.ssh_net0.name
      "ipv4.address" = "10.100.10.11"
    }
  }
}

resource "lxd_instance" "dingo" {
  name = "dingo"
  image = lxd_cached_image.jammy.fingerprint
  project = lxd_project.ssh.name
  profiles = [lxd_profile.lab.name, lxd_profile.lab_ci.name]
  
  device {
    name = "eth0"
    type = "nic"
    properties = {
      network = lxd_network.ssh_net1.name
      "ipv4.address" = "10.100.11.20"
    }
  }
}
