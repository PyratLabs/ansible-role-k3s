# Use an alternate CNI

K3S ships with Flannel, however sometimes you want an different CNI such as
Calico, Canal or Weave Net. To do this you will need to disable Flannel with
`flannel-backend: "none"`, specify a `cluster-cidr` and add your CNI manifests
to the `k3s_server_manifests_templates`.

## Calico example

The below is based on the
[Calico quickstart documentation](https://docs.projectcalico.org/getting-started/kubernetes/quickstart).

Steps:

  1. Download `tigera-operator.yaml` to the manifests directory.
  1. Download `custom-resources.yaml` to the manifests directory.
  1. Choose a `cluster-cidr` (we are using 192.168.0.0/16)
  1. Set `k3s_server` and `k3s_server_manifest_templates` as per the below,
     ensure the paths to manifests are correct for your project repo.

```yaml
---

# K3S Server config, don't deploy flannel and set cluster pod CIDR.
k3s_server:
  cluster-cidr: 192.168.0.0/16
  flannel-backend: "none"

# Deploy the following k3s server templates.
k3s_server_manifests_templates:
  - "manifests/calico/tigera-operator.yaml"
  - "manifests/calico/custom-resources.yaml"
```

All nodes should come up as "Ready", below is a 3-node cluster:

```text
 $ kubectl get nodes -o wide -w
NAME     STATUS   ROLES                       AGE    VERSION        INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
kube-0   Ready    control-plane,etcd,master   114s   v1.20.2+k3s1   10.10.9.2     10.10.9.2     Ubuntu 20.04.1 LTS   5.4.0-56-generic   containerd://1.4.3-k3s1
kube-1   Ready    control-plane,etcd,master   80s    v1.20.2+k3s1   10.10.9.3     10.10.9.3     Ubuntu 20.04.1 LTS   5.4.0-56-generic   containerd://1.4.3-k3s1
kube-2   Ready    control-plane,etcd,master   73s    v1.20.2+k3s1   10.10.9.4     10.10.9.4     Ubuntu 20.04.1 LTS   5.4.0-56-generic   containerd://1.4.3-k3s1
```

Pods should be deployed with deployed within the CIDR specified in our config
file.

```text
$ kubectl get pods -o wide -A
NAMESPACE         NAME                                      READY   STATUS      RESTARTS   AGE     IP               NODE     NOMINATED NODE   READINESS GATES
calico-system     calico-kube-controllers-cfb4ff54b-8rp8r   1/1     Running     0          5m4s    192.168.145.65   kube-0   <none>           <none>
calico-system     calico-node-2cm2m                         1/1     Running     0          5m4s    10.10.9.2        kube-0   <none>           <none>
calico-system     calico-node-2s6lx                         1/1     Running     0          4m42s   10.10.9.4        kube-2   <none>           <none>
calico-system     calico-node-zwqjz                         1/1     Running     0          4m49s   10.10.9.3        kube-1   <none>           <none>
calico-system     calico-typha-7b6747d665-78swq             1/1     Running     0          3m5s    10.10.9.4        kube-2   <none>           <none>
calico-system     calico-typha-7b6747d665-8ff66             1/1     Running     0          3m5s    10.10.9.3        kube-1   <none>           <none>
calico-system     calico-typha-7b6747d665-hgplx             1/1     Running     0          5m5s    10.10.9.2        kube-0   <none>           <none>
kube-system       coredns-854c77959c-6qhgt                  1/1     Running     0          5m20s   192.168.145.66   kube-0   <none>           <none>
kube-system       helm-install-traefik-4czr9                0/1     Completed   0          5m20s   192.168.145.67   kube-0   <none>           <none>
kube-system       metrics-server-86cbb8457f-qcxf5           1/1     Running     0          5m20s   192.168.145.68   kube-0   <none>           <none>
kube-system       traefik-6f9cbd9bd4-7h4rl                  1/1     Running     0          2m50s   192.168.126.65   kube-1   <none>           <none>
tigera-operator   tigera-operator-b6c4bfdd9-29hhr           1/1     Running     0          5m20s   10.10.9.2        kube-0   <none>           <none>
```
