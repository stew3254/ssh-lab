#!/bin/bash

cd /home/ubuntu
sudo -u ubuntu git clone https://github.com/stew3254/ssh-lab.git
cp -av /home/ubuntu/ssh-lab/ssh/* -t /home/ubuntu/.ssh
