FROM devops4me/wiki:latest

# --->
# ---> As the gollum user create wiki.dir from a clone
# ---> of the wiki content repository and set it as the
# ---> work directory.
# --->
# ---> Pass the WIKI_CONTENT_URL as a build argument.
# --->

USER gollum
ARG WIKI_CONTENT_URL
RUN git clone $WIKI_CONTENT_URL /var/opt/gollum/wiki.dir
WORKDIR /var/opt/gollum/wiki.dir
