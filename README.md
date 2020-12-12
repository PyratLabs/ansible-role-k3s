# Ansible Role: k3s (v1.x)

Ansible role for installing [Rancher Labs k3s](https://k3s.io/) ("Lightweight
Kubernetes") as either a standalone server or cluster.

[![CI](https://github.com/PyratLabs/ansible-role-k3s/workflows/CI/badge.svg?event=push)](https://github.com/PyratLabs/ansible-role-k3s/actions?query=workflow%3ACI)

## Requirements

The host you're running Ansible from requires the following Python dependencies:

  - `ansible >= 2.7 <= 2.9`
  - `jmespath >= 0.9.0`

This role has been tested against the following Linux Distributions:

  - Amazon Linux 2
  - Archlinux
  - CentOS 8
  - CentOS 7
  - Debian 9
  - Debian 10
  - Fedora 29
  - Fedora 30
  - Fedora 31
  - Fedora 32
  - openSUSE Leap 15
  - Ubuntu 18.04 LTS
  - Ubuntu 20.04 LTS

:warning: The v1 releases of this role only supports `k3s <= v1.19`, for
`k3s >= v1.19` please consider using the v2+ releases of this role.

## Disclaimer

Rancher Labs is awesome and has released k3s as v1.0.0, however at the time of
creating this role I do not have a k3s cluster in production nor am I unlikely
to ever have one. Please ensure you practice extreme caution and operational
rigor before using this role for any serious workloads.

If you have any problems please create a GitHub issue, I maintain this role in
my spare time so I cannot promise a speedy fix delivery.

## Role Variables

### Group Variables

Below are variables that are set against all of the play hosts for environment
consistency.

| Variable                                 | Description                                                                         | Default Value                              |
|------------------------------------------|-------------------------------------------------------------------------------------|--------------------------------------------|
| `k3s_cluster_state`                      | State of cluster: installed, started, stopped, restarted, downloaded, uninstalled.  | installed                                  |
| `k3s_release_version`                    | Use a specific version of k3s, eg. `v0.2.0`. Specify `false` for stable.            | `false`                                    |
| `k3s_build_cluster`                      | When multiple `play_hosts` are available, attempt to cluster. Read notes below.     | `true`                                     |
| `k3s_github_url`                         | Set the GitHub URL to install k3s from.                                             | https://github.com/rancher/k3s             |
| `k3s_skip_validation`                    | Skip all tasks that validate configuration.                                         | `false`                                    |
| `k3s_install_dir`                        | Installation directory for k3s.                                                     | `/usr/local/bin`                           |
| `k3s_install_hard_links`                 | Install using hard links rather than symbolic links.                                | `false`                                    |
| `k3s_server_manifests_dir`               | Path for place the `k3s_server_manifests_templates`.                                | `/var/lib/rancher/k3s/server/manifests`    |
| `k3s_server_manifests_templates`         | A list of Auto-Deploying Manifests Templates.                                       | []                                         |
| `k3s_use_experimental`                   | Allow the use of experimental features in k3s.                                      | `false`                                    |
| `k3s_use_unsupported_config`             | Allow the use of unsupported configurations in k3s.                                 | `false`                                    |
| `k3s_non_root`                           | Install k3s as non-root user. See notes below.                                      | `false`                                    |
| `k3s_cluster_cidr`                       | Network CIDR to use for pod IPs                                                     | 10.42.0.0/16                               |
| `k3s_service_cidr`                       | Network CIDR to use for service IPs                                                 | 10.43.0.0/16                               |
| `k3s_control_node_address`               | Use a specific control node address. IP or FQDN.                                    | _NULL_                                     |
| `k3s_control_token`                      | Use a specific control token, please read notes below.                              | _NULL_                                     |
| `k3s_private_registry`                   | Private registry configuration file (default: "/etc/rancher/k3s/registries.yaml")   | _NULL_                                     |
| `k3s_https_port`                         | HTTPS port listening port.                                                          | 6443                                       |
| `k3s_use_docker`                         | Use Docker rather than Containerd?                                                  | `false`                                    |
| `k3s_no_flannel`                         | Do not use Flannel                                                                  | `false`                                    |
| `k3s_flannel_backend`                    | Flannel backend ('none', 'vxlan', 'ipsec', 'host-gw' or 'wireguard')                | vxlan                                      |
| `k3s_no_coredns`                         | Do not use CoreDNS                                                                  | `false`                                    |
| `k3s_cluster_dns`                        | Cluster IP for CoreDNS service. Should be in your service-cidr range.               | _NULL_                                     |
| `k3s_cluster_domain`                     | Cluster Domain.                                                                     | cluster.local                              |
| `k3s_resolv_conf`                        | Kubelet resolv.conf file                                                            | _NULL_                                     |
| `k3s_no_traefik`                         | Do not use Traefik                                                                  | `false`                                    |
| `k3s_no_servicelb`                       | Do not use ServiceLB, necessary for using something like MetalLB.                   | `false`                                    |
| `k3s_no_local_storage`                   | Do not use Local Storage                                                            | `false`                                    |
| `k3s_default_local_storage_path`         | Set Local Storage Path. Specify `false` for default.                                | `false`                                    |
| `k3s_no_metrics_server`                  | Do not deploy metrics server                                                        | `false`                                    |
| `k3s_kube_apiserver_args`                | Customized flag for kube-apiserver process                                          | []                                         |
| `k3s_kube_scheduler_args`                | Customized flag for kube-scheduler process                                          | []                                         |
| `k3s_kube_controller_manager_args`       | Customized flag for kube-controller-manager process                                 | []                                         |
| `k3s_kube_cloud_controller_manager_args` | Customized flag for kube-cloud-controller-manager process                           | []                                         |
| `k3s_disable_scheduler`                  | Disable Kubernetes default scheduler                                                | `false`                                    |
| `k3s_disable_cloud_controller`           | Disable k3s default cloud controller manager.                                       | `false`                                    |
| `k3s_disable_network_policy`             | Disable k3s default network policy controller.                                      | `false`                                    |
| `k3s_disable_kube_proxy`                 | Disable k3s default kube proxy.                                                     | `false`                                    |
| `k3s_write_kubeconfig_mode`              | Define the file mode from the generated KubeConfig, eg. `644`                       | _NULL_                                     |
| `k3s_datastore_endpoint`                 | Define the database or etcd cluster endpoint for HA.                                | _NULL_                                     |
| `k3s_datastore_cafile`                   | Define the database TLS CA file.                                                    | _NULL_                                     |
| `k3s_datastore_certfile`                 | Define the database TLS Cert file.                                                  | _NULL_                                     |
| `k3s_datastore_keyfile`                  | Define the database TLS Key file.                                                   | _NULL_                                     |
| `k3s_become_for_all`                     | Enable become for all (where value for `k3s_become_for_*` is _NULL_                 | `false`                                    |
| `k3s_become_for_systemd`                 | Enable become for systemd commands.                                                 | _NULL_                                     |
| `k3s_become_for_install_dir`             | Enable become for writing to `k3s_install_dir`.                                     | _NULL_                                     |
| `k3s_become_for_usr_local_bin`           | Enable become for writing to `/usr/local/bin/`.                                     | _NULL_                                     |
| `k3s_become_for_package_install`         | Enable become for installing prerequisite packages.                                 | _NULL_                                     |
| `k3s_become_for_kubectl`                 | Enable become for kubectl commands.                                                 | _NULL_                                     |
| `k3s_become_for_uninstall`               | Enable become for running uninstall scripts.                                        | _NULL_                                     |
| `k3s_etcd_datastore`                     | Use Embedded Etcd as the database backend for HA. (EXPERIMENTAL)                    | `false`                                    |
| `k3s_etcd_disable_snapshots`             | Disable Etcd snapshots.                                                             | `false`                                    |
| `k3s_etcd_snapshot_schedule_cron`        | Etcd snapshot cron schedule.                                                        | "`* */12 * * *`"                           |
| `k3s_etcd_snapshot_retention`            | Etcd snapshot retention.                                                            | 5                                          |
| `k3s_etcd_snapshot_directory`            | Etcd snapshot directory.                                                            | `/var/lib/rancher/k3s/server/db/snapshots` |
| `k3s_secrets_encryption`                 | Use secrets encryption at rest. (EXPERIMENTAL)                                      | `false`                                 |
| `k3s_debug`                              | Enable debug logging on the k3s service                                             | `false`                                    |
| `k3s_enable_selinux`                     | Enable SELinux in containerd. (EXPERIMENTAL)                                        | `false`                                    |

#### Important note about `k3s_release_version`

If you do not set a `k3s_release_version` the latest version from the stable
channel of k3s will be installed. If you are developing against a specific
version of k3s you must ensure this is set in your Ansible configuration, eg:

```yaml
k3s_release_version: v1.16.9+k3s1
```

It is also possible to install specific K3s "Channels", below are some
examples for `k3s_release_version`:

```yaml
k3s_release_version: false             # defaults to 'stable' channel
k3s_release_version: stable            # latest 'stable' release
k3s_release_version: testing           # latest 'testing' release
k3s_release_version: v1.18             # latest v1.18 release
k3s_release_version: v1.17-testing     # latest v1.17 testing release
k3s_release_version: v1.19.2-k3s1      # specific release

# specific commit
# caution - only used for tesing - must be 40 characters
k3s_release_version: 48ed47c4a3e420fa71c18b2ec97f13dc0659778b
```

#### Important node about `k3s_install_hard_links`

If you are using the [system-upgrade-controller](https://github.com/rancher/system-upgrade-controller)
you will need to use hard links rather than symbolic links as the controller
will not be able to follow symbolic links. This option has been added however
is not enabled by default to avoid breaking existing installations.

To enable the use of hard links, ensure `k3s_install_hard_links` is set
to `true`.

```yaml
k3s_install_hard_links: true
```

The result of this can be seen by running the following in `k3s_install_dir`:

`ls -larthi | grep -E 'k3s|ctr|ctl' | grep -vE ".sh$" | sort`

Symbolic Links:

```text
[root@node1 bin]# ls -larthi | grep -E 'k3s|ctr|ctl' | grep -vE ".sh$" | sort
3277823 -rwxr-xr-x 1 root root  52M Jul 25 12:50 k3s-v1.18.4+k3s1
3279565 lrwxrwxrwx 1 root root   31 Jul 25 12:52 k3s -> /usr/local/bin/k3s-v1.18.6+k3s1
3279644 -rwxr-xr-x 1 root root  51M Jul 25 12:52 k3s-v1.18.6+k3s1
3280079 lrwxrwxrwx 1 root root   31 Jul 25 12:52 ctr -> /usr/local/bin/k3s-v1.18.6+k3s1
3280080 lrwxrwxrwx 1 root root   31 Jul 25 12:52 crictl -> /usr/local/bin/k3s-v1.18.6+k3s1
3280081 lrwxrwxrwx 1 root root   31 Jul 25 12:52 kubectl -> /usr/local/bin/k3s-v1.18.6+k3s1
```

Hard Links:

```text
[root@node1 bin]# ls -larthi | grep -E 'k3s|ctr|ctl' | grep -vE ".sh$" | sort
3277823 -rwxr-xr-x 1 root root  52M Jul 25 12:50 k3s-v1.18.4+k3s1
3279644 -rwxr-xr-x 5 root root  51M Jul 25 12:52 crictl
3279644 -rwxr-xr-x 5 root root  51M Jul 25 12:52 ctr
3279644 -rwxr-xr-x 5 root root  51M Jul 25 12:52 k3s
3279644 -rwxr-xr-x 5 root root  51M Jul 25 12:52 k3s-v1.18.6+k3s1
3279644 -rwxr-xr-x 5 root root  51M Jul 25 12:52 kubectl
```

#### Important note about `k3s_build_cluster`

If you set `k3s_build_cluster` to `false`, this role will install each play
host as a standalone node. An example of when you might be building a large
number of IoT devices running K3s. Below is a hypothetical situation where we
are to deploy 25 Rasberry Pi devices, each a standalone system and not
a cluster of 25 nodes. To do this we'd use a playbook similar to the below:

```yaml
- hosts: k3s_nodes  # eg. 25 RPi's defined in our inventory.
  vars:
    k3s_build_cluster: false
  roles:
     - xanmanning.k3s
```

#### Important note about `k3s_non_root`

To install k3s as non root you must not use `become: true`. The intention of
this variable is to run a single node development environment. At the time
of release v1.0.1, rootless is still experimental.

You must also ensure that you set both `k3s_use_experimental`
and `k3s_use_unsupported_config` to `true`.

Additionally `k3s_install_dir` must be writable by your user.

#### Important notes about `k3s_control_node_address` and `k3s_control_token`

If you set this, you are explicitly specifying the control host that agents
should connect to, the value should be an IP address or FQDN.

If the control host is not configured by this role, then you need to also
specify the `k3s_control_token`.

Please note that this may potentially break setting up agents.

### Host Variables

Below are variables that are set against specific hosts in your inventory.

| Variable                    | Description                                                                      | Default Value          |
|-----------------------------|----------------------------------------------------------------------------------|------------------------|
| `k3s_control_node`          | Define the host as a control plane node, (True/False).                           | `false`                |
| `k3s_node_name`             | Define the name of this node.                                                    | `$(hostname)`          |
| `k3s_node_id`               | Define the ID of this node.                                                      | _NULL_                 |
| `k3s_flannel_interface`     | Define the flannel proxy interface for this node.                                | _NULL_                 |
| `k3s_advertise_address`     | Define the advertise address for this node.                                      | _NULL_                 |
| `k3s_bind_address`          | Define the bind address for this node.                                           | localhost              |
| `k3s_node_ip_address`       | IP Address to advertise for this node.                                           | _NULL_                 |
| `k3s_node_external_address` | External IP Address to advertise for this node.                                  | _NULL_                 |
| `k3s_node_labels`           | List of node labels.                                                             | _NULL_                 |
| `k3s_kubelet_args`          | A list of kubelet args to pass to the server.                                    | []                     |
| `k3s_kube_proxy_args`       | A list of kube proxy args to pass to the server.                                 | []                     |
| `k3s_node_taints`           | List of node taints.                                                             | _NULL_                 |
| `k3s_node_data_dir`         | Folder to hold state.                                                            | `/var/lib/rancher/k3s` |
| `k3s_tls_san`               | A list of additional hosnames or IPs as Subject Alternate Name in the TLS cert.  | []                     |

#### Important note about `k3s_control_node` and High Availability (HA)

By default only one host will be defined as a control node by Ansible, If you
do not set a host as a control node, this role will automatically delegate
the first play host as a primary control node. This is not suitable for use in
a Production workload.

If multiple hosts have `k3s_control_node` set to true, you must also set
`k3s_datastore_endpoint` as the connection string to a MySQL or PostgreSQL
database, or external Etcd cluster else the play will fail.

If using TLS, the CA, Certificate and Key need to already be available on
the play hosts.

See: [High Availability with an External DB](https://rancher.com/docs/k3s/latest/en/installation/ha/)

It is also possible, though not supported, to run a single K3s control node with a
`k3s_datastore_endpoint` defined. As this is not a typically supported
configuration you will need to set `k3s_use_unsupported_config` to `true`.

Since K3s v1.19.1 it is possible to use Etcd as the backend database, and this
is done by setting `k3s_etcd_datastore` to true. As this is an experimental
feature you will also need to set `k3s_use_experimental` to `true`. The best
practice for Etcd is to define at least 3 members to ensure quorum is
established. In addition to this, an odd number of members is recommended to
ensure a majority in the event of a network partition. If you want to use 2
members or an even number of members, please set `k3s_use_unsupported_config`
to `true`.

#### Important note about `k3s_flannel_interface`

If you are running k3s on systems with multiple network interfaces, it is
necessary to have the flannel interface on a network interface that is routable
to the control plane node(s).

#### Notes about `_args`, `_labels` and `_taints` variables

Affected variables:

  - `k3s_kube_apiserver_args`
  - `k3s_kube_scheduler_args`
  - `k3s_kube_controller_manager_args`
  - `k3s_kube_cloud_controller_manager_args`
  - `k3s_kubelet_args`
  - `k3s_kube_proxy_args`

These parameters allow for assigning additional args to K3s during runtime.
For instance, to use the Azure Cloud Controller, assign the below to
the control node's configuration in your host file.

**YAML**:

```yaml
k3s_kubelet_args:
  - cloud-provider: external
  - provider-id: azure
```

_Note, when using an external cloud controller as above, ensure that the native
k3s cloud controller is disabled by setting the_ `k3s_disable_cloud_controller`
_to_ `true`.

Ultimately these variables are lists of key-value pairs that will be iterated
on. The below example will output the following:

**YAML**:

```yaml
k3s_node_labels:
  - foo: bar
  - hello: world

k3s_node_taints:
  - key1: value1:NoExecute
```

**K3S ARGS**:

```text
--node-label foo=bar \
--node-label hello=world \
--node-taint key1=value1:NoExecute
```

## Dependencies

No dependencies on other roles.

## Example Playbooks

Example playbook, single control node running v0.10.2:

```yaml
- hosts: k3s_nodes
  roles:
     - { role: xanmanning.k3s, k3s_release_version: v0.10.2 }
```

Example playbook, Highly Available running the latest release:

```yaml
- hosts: k3s_nodes
  vars:
    molecule_is_test: true
    k3s_control_node_address: loadbalancer
    k3s_datastore_endpoint: "postgres://postgres:verybadpass@database:5432/postgres?sslmode=disable"
  pre_tasks:
    - name: Set each node to be a control node
      set_fact:
        k3s_control_node: true
      when: inventory_hostname in ['node2', 'node3']
  roles:
    - role: xanmanning.k3s
```

## License

[BSD 3-clause](LICENSE.txt)

## Contributors

Please check out the awesome
[list of contributors](https://github.com/PyratLabs/ansible-role-k3s/graphs/contributors).

## Author Information

[Xan Manning](https://xan.manning.io/)
