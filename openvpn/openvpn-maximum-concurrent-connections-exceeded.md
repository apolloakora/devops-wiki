
# OpenVpn | Access Server license failure | maximum concurrent_connections exceeded

How do you handle this OpenVpn (in syslog) error - **AUTH_FAILED** | **LICENSE: Access Server license failure** | **maximum concurrent_connections exceeded**.

The OpenVpn server thinks you have more than the configured (n) concurrent connections. If you use NetworkManager it just keeps asking you for your password time and again.

Sometimes this error occurs when you haven't got any concurrent connections. You reboot your laptop to no avail.

You should consider the following questions/solutions.

- has someone somewhere hacked your VPN and is using it?
- did you leave your VPN running in the office or on another machine?
- could you up the concurrent connection allocation on the server?
- could you create another user temporarily or otherwise?
- have you checked your username and password in **/etc/NetworkManager/system-connections/<<connection>>**.
- have you removed this line from the above network manager profile **`never-default=true`**
- calling NetworkManager from the command line using **nmcli**

It makes no sense but **using the nmcli (network manager command line)** often resolves the **maximum concurrent_connections exceeded** error.
Visit how to **[[start and stop OpenVpn on the command line|openvpn]]**

### OpenVpn syslog | Maximum Concurrent Connections Exceeded

```
nm-openvpn[6976]: AUTH: Received control message: AUTH_FAILED,LICENSE: Access Server license failure: maximum concurrent_connections exceeded (2)
```


