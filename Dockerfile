FROM devops4me/wiki:latest

# --->
# ---> Copy the Wiki content in the repository into the
# ---> docker machine.
# --->

USER gollum

RUN rm -fr /var/opt/goluum/wiki.dir
RUN git clone https://github.com/apolloakora/devops-wiki.git /var/opt/gollum/wiki.dir

# ---------------> COPY . .

RUN pwd
RUN ls -lah
# -----------------> RUN chown -R gollum:gollum /var/opt/gollum/wiki.dir

# -----------> RUN rm -fr .git
# -----------> RUN git init

