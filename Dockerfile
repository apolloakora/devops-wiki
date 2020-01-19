FROM devops4me/wiki:latest

# --->
# ---> As the gollum user create wiki.dir from a clone
# ---> of tthe wiki content repository and set it as the
# ---> work directory.
# --->

USER gollum
RUN git clone https://github.com/apolloakora/devops-wiki.git /var/opt/gollum/wiki.dir
WORKDIR /var/opt/gollum/wiki.dir

RUN pwd
RUN ls -lah
RUN git config --list
