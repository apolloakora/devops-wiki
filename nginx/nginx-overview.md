
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


---


## how to run nginx inside a docker container

```
docker run -it --name vm.nginx -p 80:80 nginx
```

Now visit http://localhost and the nginx welcome page should show.


---


## how to add HTML, PDFs, Images to nginx

The default content directory is **`/usr/share/nginx/html`** in the nginx docker image.

To add custom content to an nginx docker container you can

- **either** use Dockerfile COPY (or ADD) to move it into the image
- **or** use **`docker cp`** to move it in whilst the container is running

The primary nginx configuration file is **`/etc/nginx/nginx.conf`**.


<!-- facts
authority = web server, reverse proxy, nginx, 443, port 80
-->
