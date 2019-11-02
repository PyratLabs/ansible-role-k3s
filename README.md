# Ansible Role: k3s

Ansible role for installing [Racher Labs k3s](https://k3s.io/) ("Lightweight
Kubernetes") as either a standalone server or cluster.

[![Build Status](https://www.travis-ci.org/PyratLabs/ansible-role-k3s.svg?branch=master)](https://www.travis-ci.org/PyratLabs/ansible-role-k3s)

## Requirements

This role has been tested on Ansible 2.6.0+ against the following Linux Distributions:

  - Amazon Linux 2
  - CentOS 8
  - CentOS 7
  - Debian 9
  - Debian 10
  - Fedora 29
  - Fedora 30
  - Fedora 31
  - openSUSE Leap 15
  - Ubuntu 18.04 LTS

## Disclaimer

:warning: Not suitable for production use.

Whilst Rancher Labs are awesome, k3s is a fairly new project and not yet a v1.0
release so extreme caution and operational rigor is recommended before using
this role for any serious development.

## Role Variables

### Group Variables

Below are variables that are set against all of the play hosts for environment
consistency.

| Variable                       | Description                                                              | Default Value                  |
|--------------------------------|--------------------------------------------------------------------------|--------------------------------|
| `k3s_release_version`          | Use a specific version of k3s, eg. `v0.2.0`. Specify `false` for latest. | `false`                        |
| `k3s_github_url`               | Set the GitHub URL to install k3s from.                                  | https://github.com/rancher/k3s |
| `k3s_install_dir`              | Installation directory for k3s.                                          | `/usr/local/bin`               |
| `k3s_control_workers`          | Are control hosts also workers?                                          | `true`                         |
| `k3s_https_port`               | HTTPS port listening port.                                               | 6443                           |
| `k3s_use_docker`               | Use Docker rather than Containerd?                                       | `false`                        |
| `k3s_no_flannel`               | Do not use Flannel                                                       | `false`                        |
| `k3s_flannel_backend`          | Flannel backend ('none', 'vxlan', 'ipsec', or 'wireguard')               | vxlan                          |
| `k3s_no_coredns`               | Do not use CoreDNS                                                       | `false`                        |
| `k3s_cluster_dns`              | Cluster IP for CoreDNS service. Should be in your service-cidr range.    | _NULL_                         |
| `k3s_cluster_domain`           | Cluster Domain.                                                          | cluster.local                  |
| `k3s_no_traefik`               | Do not use Traefik                                                       | `false`                        |
| `k3s_no_servicelb`             | Do not use ServiceLB, necessary for using something like MetalLB.        | `false`                        |
| `k3s_disable_scheduler`        | Disable Kubernetes default scheduler                                     | `false`                        |
| `k3s_disable_cloud_controller` | Disable k3s default cloud controller manager.                            | `false`                        |
| `k3s_disable_network_policy`   | Disable k3s default network policy controller.                           | `false`                        |

#### Important note about `k3s_release_version`

If you do not set a `k3s_release_version` the latest version of k3s will be
installed. If you are developing against a specific version of k3s you must
ensure this is set in your Ansible configuration, eg:

```yaml
k3s_release_version: v0.2.0
```

### Host Variables

Below are variables that are set against specific hosts in your inventory.

| Variable                    | Description                                            | Default Value |
|-----------------------------|--------------------------------------------------------|---------------|
| `k3s_control_node`          | Define the host as a control plane node, (True/False). | `false`       |
| `k3s_node_name`             | Define the name of this node.                          | `$(hostname)` |
| `k3s_flannel_interface`     | Define the flannel proxy interface for this node.      | _NULL_        |
| `k3s_bind_address`          | Define the bind address for this node.                 | localhost     |
| `k3s_node_ip_address`       | IP Address to advertise for this node.                 | _NULL_        |
| `k3s_node_external_address` | External IP Address to advertise for this node.        | _NULL_        |
| `k3s_node_labels`           | List of node labels.                                   | _NULL_        |
| `k3s_node_taints`           | List of node taints.                                   | _NULL_        |

#### Important note about `k3s_control_node`

Currently only one host can be defined as a control node, if multiple hosts are
set to true the play will fail.

If you do not set a host as a control node, the role will automatically delegate
the first play host as a control node.

#### Important note about `k3s_flannel_interface`

If you are running k3s on systems with multiple network interfaces, it is
necessary to have the flannel interface on a network interface that is routable
to the master node(s).

#### Notes about `k3s_node_labels` and `k3s_node_taints`

Both these variables are lists that will be iterated on. The below example will
output the following:

**YAML**:

```yaml
k3s_node_labels:
  - foo: bar
  - hello: world

k3s_node_taints:
  - key1: value1:NoExecute
```

**ARGS**:

```text
--node-label foo=bar \
--node-label hello=world \
--node-taint key1=value1:NoExecute
```

## Dependencies

No dependencies on other roles.

## Example Playbook

Example playbook:

```yaml
- hosts: k3s_nodes
  roles:
     - { role: xanmanning.k3s, k3s_release_version: v0.10.2 }
```

## License

BSD

## Author Information

[Xan Manning](https://xanmanning.co.uk/)
