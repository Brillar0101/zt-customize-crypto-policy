#!/bin/bash

# Unregister and register the VM
dnf -y remove katello-ca-consumer-*
subscription-manager clean
subscription-manager register --activationkey=$ACTIVATION_KEY --org=$ORG_ID --force

# Install the mod_ssl moved to instance.yml
# dnf install -y httpd mod_ssl
systemctl --now enable httpd

# Once we have a SSL cert created at DEFAULT 2048 bit, we can up the policy for the lab
update-crypto-policies --set FUTURE

# fix ssh issue
echo "KexAlgorithms +curve25519-sha256,ecdh-sha2-nistp256,ecdh-sha2-nistp384" >> /etc/ssh/sshd_config
systemctl restart sshd

