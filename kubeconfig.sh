#!/usr/bin/env bash

# set -eu
export LC_ALL=C


ROOT=$(dirname "${BASH_SOURCE}")
LOCAL_KUBE_CERTS_DIR="${ROOT}/../kubernetes-chart/certs"

KUBE_API_SERVICE_EXTERNAL_IP=${KUBE_API_SERVICE_EXTERNAL_IP:-"192.168.11.101"}

KUBE_ADMIN_KUBECONFIG=${KUBE_ADMIN_KUBECONFIG:-"${ROOT}/admin.yaml"}

CA_CERT=${KUBE_CA_CERT:-"${LOCAL_KUBE_CERTS_DIR}/ca.crt"}
KUBE_ADMIN_KEY=${KUBE_ADMIN_KEY:-"${LOCAL_KUBE_CERTS_DIR}/admin.key"}
KUBE_ADMIN_CERT=${KUBE_ADMIN_CERT:-"${LOCAL_KUBE_CERTS_DIR}/admin.crt"}

CA_DATA=$(cat ${CA_CERT} | base64 | tr -d '\n')
CLIENT_CERTS_DATA=$(cat ${KUBE_ADMIN_CERT} | base64 | tr -d '\n')
CLIENT_KEY_DATA=$(cat ${KUBE_ADMIN_KEY} | base64 | tr -d '\n')

cat << EOF > ${KUBE_ADMIN_KUBECONFIG}
apiVersion: v1
kind: Config
clusters:
- name: kubernetes
  cluster:
    certificate-authority-data: ${CA_DATA}
    server: https://${KUBE_API_SERVICE_EXTERNAL_IP}:443
users:
- name: admin
  user:
    client-certificate-data: ${CLIENT_CERTS_DATA}
    client-key-data: ${CLIENT_KEY_DATA}
contexts:
- context:
    cluster: kubernetes
    user: admin
  name: tenant-a
current-context: tenant-a
EOF

export KUBECONFIG=${KUBE_ADMIN_KUBECONFIG}
