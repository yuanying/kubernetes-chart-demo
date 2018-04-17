#!/usr/bin/env bash

## Require root priviledges

cat <<EOF >> /etc/hosts
172.18.201.101 k8s-as-a-service
172.18.202.101 demo-kubernetes
172.18.202.121 ubuntu-worker01
172.18.202.122 ubuntu-worker02
EOF
