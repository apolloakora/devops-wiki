

# Provision and Install a SSL (HTTPS) Certificate

There are four key ways to provision and install a SSL (HTTPS) certificate

- auto provisioning using services like **Let's Encrypt** and **Certbot**
- provisioning it manually from certificate authorities like GoDaddy and Verisign
- using a cloud provisioned SSL certificate like the AWS Certificate Manager
- declare yourself a certificate authority and sign your own certs

To get the green text (in browser url bar) using extended verification certificates you must use the manual option. Also for SEO the manual option gives your website a higher search engine ranking.

The cloud or the Let's Encrypt (Certbot) options are perfect for web facing test and canary systems.

For a locked down internal only service that includes a VPN and installing certicates on workstations and in browsers, the self-declared certificate authority root gives you more control (like revocation rights) but is much more complex, time consuming and comes with a hefty total cost of ownership.

## Use Cases for Provisioning and Installation

These use cases walk us through the steps to achieving websites, REST API endpoints and ssh logins using the secure SSL (HTTPS) protocol.

- provision with GoDaddy then auto install into nginx


