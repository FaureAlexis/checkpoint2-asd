#!/bin/bash

apt update && apt install -y sudo

useradd -m -s /bin/bash ubuntu && mkdir -p /home/ubuntu/.ssh && echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4/17BbulXDkaNr0imPmLi1B2IqsBEWdF9pATmjb9Uy wordpress_server" > /home/ubuntu/.ssh/authorized_keys && chown -R ubuntu:ubuntu /home/ubuntu/.ssh && chmod 700 /home/ubuntu/.ssh && chmod 600 /home/ubuntu/.ssh/authorized_keys && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu
usermod -aG sudo ubuntu && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu && chmod 0440 /etc/sudoers.d/ubuntu
echo 'ubuntu:SomeSecurePass123!' | chpasswd