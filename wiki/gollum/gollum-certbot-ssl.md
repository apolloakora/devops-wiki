
# Gollum Wiki SSL Using Certbot

Adding HTTPS/SSL to a Gollum Wiki is the subject of this page. Read on if you want to

- add HTTPS / SSL to your **Gollum Wiki**
- use Certbot to produce the SSL Certificates
- use **NginX** to *reverse proxy* Gollum requests
- enforce the use of HTTPS/SSL


## Gollum SSL PreConditions

Your Gollum Wiki must be running on bare metal, within the cloud, or in a **Docker Container**.


sudo apt-get install --assume-yes nginx


<!-- facts

authority = Lets Encrypt, LetsEncrypt, Gollum Https

-->

The End
