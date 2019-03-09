# k3s

Ansible role for installing k3s as either a standalone server or cluster.

## Requirements

This role has been tested on Ansible 2.6.0+ against the following Linux Distributions:

  - CentOS 7
  - Debian 9
  - Ubuntu 18.04 LTS

## Role Variables

| Variable                       | Description                                                              | Default Value                  |
|--------------------------------|--------------------------------------------------------------------------|--------------------------------|
| `k3s_release_version`          | Use a specific version of k3s, eg. `v0.1.0`. Specify `false` for latest. | `false`                        |
| `k3s_github_url`               | Set the GitHub URL to install k3s from.                                  | https://github.com/rancher/k3s |
| `k3s_install_dir`              | Installation directory for k3s.                                          | `/usr/local/bin`               |
| `k3s_control_workers`          | Are control hosts also workers?                                          | `true`                         |
| `k3s_ensure_docker_installed ` | Use Docker rather than Containerd?                                       | `false`                        |


## Dependencies

No dependencies on other roles.

## Example Playbook

Example playbook:

```yaml
- hosts: k3s_nodes
  roles:
     - { role: xanmanning.k3s, k3s_control_workers: false }
```

## License

BSD

## Author Information

[Xan Manning](https://xanmanning.co.uk/)
