
# nginx | why use it?

A well configured ***(reverse proxy)*** nginx service between web requests and applications

- provides an uplift in performance
- enhances your application stack security
- enables applications to consume less resources
- allows caching, compression, consistent logging, and more
- load balances and raises hroughput by terminating upstream connections


Security is considerably enhanced when you employ the reverse proxy pattern. Separating the client from the application is more secure because

- we only need open 2 ports (80 and 443) to the outside world
- it can terminate HTTPS/SSL traffic for apps that cannot robustly provide this
- nginx access control lists can block requests from blacklisted clients
- mail that is intrinsically toxic can be safely ringfenced

<!-- facts
authority = web server, reverse proxy, nginx, 443, port 80
-->
