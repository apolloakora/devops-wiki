
# Common Ubuntu Problems

Everything in the universe ***is fallable** - *operating systems* and *platform services* are no exception.

## apt could not get lock | unable to lock the administration directory

<pre>
E: Could not get lock /var/lib/dpkg/lock - open (11: Resource temporarily unavailable)
E: Unable to lock the administration directory (/var/lib/dpkg/), is another process using it?
</pre>

This error occurs after an attempt to run ***apt-get*** - usually <code>sudo apt-get install</code>...

To fix it

> ps aux | grep apt

<pre>
apollo   19284  0.0  0.0  14228   980 pts/1    S+   12:06   0:00 grep --color=auto apt
</pre>

In this case the process number is ***19284***. Use this to kill the process.

> sudo kill 19284

or

> sudo kill -9 19284

Then continue using apt-get.

