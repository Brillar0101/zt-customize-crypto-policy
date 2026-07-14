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
echo "key_exchange = +ECDHE-ECDSA +ECDHE-RSA +DHE-RSA" > /etc/crypto-policies/policies/modules/LABFIX.pmod
echo "group = +X25519 +SECP256R1 +SECP384R1 +FFDHE-2048" >> /etc/crypto-policies/policies/modules/LABFIX.pmod
update-crypto-policies --set FUTURE:LABFIX

