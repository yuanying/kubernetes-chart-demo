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
cd ${GOPATH}/src/github/yuanying/kubernetes-chart-demo
kubectl apply -f etcd-operator/
```

### metallb

```bash
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

### Create k8s control plane for tenant

### Join tenant VM in cluster

### Deploy nginx to tenant k8s cluster
