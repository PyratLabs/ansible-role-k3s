# systemd config

Below are examples to tweak how and when K3S starts up.

## Wanted service units

In this example, we're going to start K3S after Wireguard. Our example server
has a Wireguard connection `wg0`. We are using "wants" rather than "requires"
as it's a weaker requirement that Wireguard must be running. We then want
K3S to start after Wireguard has started.

```yaml
---

k3s_service_wants:
  - wg-quick@wg0.service
k3s_service_after:
  - wg-quick@wg0.service
```
