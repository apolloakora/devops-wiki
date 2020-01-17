FROM devops4me/wiki:latest

# --->
# ---> Copy the Wiki content in the repository into the
# ---> docker machine.
# --->

COPY . .
