# SSH Lab

This repository is used to teach users some real world examples of the power of ssh. It's built off of LXD using Terraform to build the lab

## Required Configuration

You will need to initialize a LXD server, create a remote storage pool, and install Terraform. This can be done easily on an Ubuntu machine as follows

```
sudo snap install terraform --classic
sudo snap install lxd
sudo lxd init --auto
```

Now you should be able to build the lab using the following commands

```
terraform init

# Optional Terraform plan to see what it will do
terraform plan

terraform apply
```
