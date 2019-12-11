
# Uncover Jenkins Credentials | Reverse Engineer Jenkins Credentials

Did you forget credentials that are sitting in Jenkins? Do you have a snooty sys admin that says "I've already gave you the credentials" - I'm not going to give it to you again.

The Jenkins Credentials Manager plugin will give up credential values really easily - that's kind of its job. The two ways to get them are
- **create a Jenkinsfile with the credentials ID as input environment variables then log them**
- **use the Jenkins admin key and the crypted teext to reverse engineer the credentials**

This article takes the second approach, where **you have access to the Jenkins home** directory.

## Step 1 | The credentials.xml file

**credentials.xml** is usually directly in the Jenkins home directory or it can be in a job-specific **`$JENKINS_HOME/job/<JOB_NAME>/`** directory.

<username>jenkins-user@mycompany.com</username>
<password>{AQAAABAAAAAgyqp9mI73xTYaYkaMRNolxwxR+X0qev7q6Hb3KcchbM9VA5ERj0RG1Nrl/aFw7haU}</password>

Now, start working your way up the tag hierarchy till you come across a tag that looks like a fully qualified Java class name, perhaps, something like this:
credentials.xml

<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
  <scope>SYSTEM</scope>
  <id>5dc3bbe5-e5a6-496e-a616-199a207d8122</id>
  <description>This is a user</description>
  <username>jenkins-user@mycompany.com</username>
  <password>{AQAAABAAAAAgyqp9mI73xTYaYkaMRNolxwxR+X0qev7q6Hb3KcchbM9VA5ERj0RG1Nrl/aFw7haU}</password>
</com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>

Cool! So now we know the class that Jenkins instantiates to support this property.

Now, we need to find the source code, and establish what mechanism this class uses to encrypt/decrypt the password. Use your favorite search engine to locate the source, in our case we simply search for com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl.

A quick review of the source reveals this constructor:
UsernamePasswordCredentialsImpl constructor

@DataBoundConstructor
@SuppressWarnings("unused") // by stapler
public UsernamePasswordCredentialsImpl(@CheckForNull CredentialsScope scope,
                                       @CheckForNull String id, @CheckForNull String description,
                                       @CheckForNull String username, @CheckForNull String password) {
    super(scope, id, description);
    this.username = Util.fixNull(username);
    this.password = Secret.fromString(password);
}

Ah! So com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl uses hudson.util.Secret to encrypt the password. Next stop, hudson.util.Secrets source code, which in turn reveals a decrypt method!
Secret#decrypt

@CheckForNull
public static Secret decrypt(@CheckForNull String data) {
  // code left out for brevity's sake.
}

We now know what class is used to encrypt/decrypt the password, the only question that remains is how do we use it? We could try to simplify the implementation and somehow manage to run it on it’s own, maybe in a test class with a main method, but that is certainly painful especially if this class has dependencies on other classes.

What we need is a runtime where we can load this class, and all of its dependencies and simply invoke hudson.util.Secret#decrypt passing in the password we found in credentials.xml.

Guess what? We have the runtime already available to us. It’s Jenkins itself!
Using the Script Console to uncover the password

Jenkins ships with a Script Console which we can use to arbitrarily run Groovy scripts [2]. In the script console we could simply run the following:
Script Console

import hudson.util.Secret;

println Secret.decrypt("{AQAAABAAAAAgyqp9mI73xTYaYkaMRNolxwxR+X0qev7q6Hb3KcchbM9VA5ERj0RG1Nrl/aFw7haU}");

// outputs super_secret_password!

Woot! There you have it. We have our camouflaged password available to us in plain text!

That’s pretty much all there is to it.
Running your own experiments

Experimenting with this need not be a perilous affair involving your production-grade Jenkins installation. You can try all of the above if you run Jenkins in Docker. Here are the steps

    Run Jenkins in Docker with docker run -p 8080:8080 --name myjenkins jenkins

    Keep an eye on the logs because Jenkins will spit out the default admin login that you will need to log in initially. You should see something like this in the logs
    Jenkins Log

    Jenkins initial setup is required. An admin user has been created and a password generated.
    Please use the following password to proceed to installation:

    016b9b01454f418caf2dab842474b351

    This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

    Now, navigate to http://localhost:8080/, enter the administrator password you garnered from the log.

    This should bring up Jenkins "Customize Jenkins" screen Simply hit the X on the top left (we will install the plugins we need for this experiment), and then on the next screen click "Start using Jenkins"

    Next, navigate to the "Plugin Manager" and install the Github Plugin. Be sure to restart Jenkins right after installation completes

    Once Jenkins has restarted, navigate to "Configure System", click on "Add Github Server" under the "Github" section It does not matter what you put in here — our intent is to simply put in enough information to appease Jenkins. Next to "Credentials" pick "Jenkins" from the "Add" pulldown, and add a "Username with password" credential. Again it does not matter what you put here - the idea is to simply have Jenkins store a set of credentials for us.

That’s all the setup you need. Now you can get to the Jenkins installation directory using docker exec like so
Docker exec

# we use the same "name" as provided docker run with
$ docker exec -it myjenkins /bin/bash

# inside the container,
> cd /var/jenkins_home/

Now go exploring!

It must be noted that the Github Plugin depends on the Credentials Plugin, which in turn, as I mentioned earlier, stores the credentials in credentials.xml.
Summary

In short, here are the requirements if you ever need to do this

    You will need administrative access to Jenkins (without which you can’t get to the Script Console) as well admin privileges to the Jenkins installation itself

    Then, you will need to determine exactly where the username/password are stored I have listed a few locations in this post where you ought to go looking, and as I have mentioned before, never underestimate the power of simple grep

    Once you have the location, you will need to determine what class Jenkins uses for that particular property, and trace its source to find the class and method used to encrypt/decrypt the password

    Finally, use the "Script Console" to use that particular class and associated decrypt method along with the password you find on disk to get the real password in plain text

