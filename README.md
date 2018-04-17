# kubernetes-chart-demo
Demo for kubernetes-chart

## Clone repositories

```bash
ghq get yuanying/kubernetes-chart
ghq get yuanying/kubernetes-chart-demo
```
### Deploy prerequisite components

### etcd-operator

```bash
# [k8s-as-a-service/default]
cd ${GOPATH}/src/github/yuanying/kubernetes-chart-demo
kubectl apply -f etcd-operator/
```

### metallb

```bash
# [k8s-as-a-service/default]
cd ${GOPATH}/src/github/yuanying/kubernetes-chart-demo
kubectl apply -f metallb/
```

## Demo

1.  Confirm KaaS Environment
2.  Create tenant namespace
3.  Create k8s control plane for tenant
4.  Join tenant VM in cluster
5.  Deploy nginx to tenant k8s cluster

### Confirm KaaS Environment

```
[k8s-as-a-service/tenant-a]$ kubectl cluster-info
Kubernetes master is running at https://k8s-as-a-service:6443
CoreDNS is running at https://k8s-as-a-service:6443/api/v1/namespaces/kube-system/services/core-dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
[k8s-as-a-service/default]$ kubectl get nodes -o wide
NAME             STATUS    ROLES     AGE       VERSION   EXTERNAL-IP   OS-IMAGE                       KERNEL-VERSION   CONTAINER-RUNTIME
172.18.201.111   Ready     master    6d        v1.9.2    <none>        Debian GNU/Linux 9 (stretch)   4.14.11-coreos   docker://17.9.0
172.18.201.112   Ready     master    6d        v1.9.2    <none>        Debian GNU/Linux 9 (stretch)   4.14.11-coreos   docker://17.9.0
172.18.201.113   Ready     master    6d        v1.9.2    <none>        Debian GNU/Linux 9 (stretch)   4.14.11-coreos   docker://17.9.0
172.18.201.121   Ready     <none>    6d        v1.9.2    <none>        Debian GNU/Linux 9 (stretch)   4.14.11-coreos   docker://17.9.0
172.18.201.122   Ready     <none>    6d        v1.9.2    <none>        Debian GNU/Linux 9 (stretch)   4.14.11-coreos   docker://17.9.0
172.18.201.123   Ready     <none>    6d        v1.9.2    <none>        Debian GNU/Linux 9 (stretch)   4.14.11-coreos   docker://17.9.0
[k8s-as-a-service/default]$ kubectl get namespace
NAME             STATUS    AGE
default          Active    6d
etcd-operator    Active    6d
kube-public      Active    6d
kube-system      Active    6d
metallb-system   Active    6d
```

### Create tenant namespace

```bash
# [k8s-as-a-service/default]
cat <<EOF | kubectl create -f -
kind: Namespace
apiVersion: v1
metadata:
  name: "tenant-a"
EOF
kubectl get namespace
kubectl config set-context k8s-as-a-service --namespace tenant-a
# [k8s-as-a-service/tenant-a]
kubectl get deployment,pod,service,configmap,etcdcluster -o wide
```

### Create k8s control plane for tenant

#### Generate cert assets

```bash
# [k8s-as-a-service/tenant-a]
cd ${GOPATH}/src/github/yuanying/kubernetes-chart-demo
source env.sh
bash ../kubernetes-chart/scripts/render-certs.sh
bash ../kubernetes-chart/scripts/render-secrets.sh
kubectl apply -f ../kubernetes-chart/secrets/
kubectl get secrets
```

#### Install k8s control plane

```bash
# [k8s-as-a-service/tenant-a]
cd ${GOPATH}/src/github/yuanying/kubernetes-chart-demo
cat values.yaml
helm install --name demo \
             -f values.yaml \
             --namespace tenant-a \
             ../kubernetes-chart
```

### Join tenant VM in cluster

#### Confirm provided tenant k8s cluster

```bash
# [tenant-a/default]
kubectl cluster-info
kubectl get node -o wide
kubectl version
```

#### Register bootstrap token

```bash
# [tenant-a/default]
bash ../kubernetes-chart/scripts/bootstrap.sh
```

#### kubeadm join

```bash
ssh ubuntu@ubuntu-worker01
kubeadm join --token xxxxxx.xxxxxxxxxxxxxxxx demo-kubernetes:443 --discovery-token-unsafe-skip-ca-verification
exit
ssh ubuntu@ubuntu-worker02
kubeadm join --token xxxxxx.xxxxxxxxxxxxxxxx demo-kubernetes:443 --discovery-token-unsafe-skip-ca-verification
exit
```

#### Confirm tenant k8s nodes

```bash
# [tenant-a/default]
kubectl get nodes -o wide
kubectl get pod -o wide --all-namespaces
```

### Deploy nginx to tenant k8s cluster

```bash
kubectl run my-nginx --image=nginx --replicas=2 --port=80
kubectl expose deployment my-nginx --type=NodePort
```
