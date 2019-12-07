
The easiest way to install RabbitMQ server is to check it's package in Package Manager of Linux system, in apt-get or aptitude in terminal or in Synaptic Manager, if you use window manager.

Before we start installing RabbitMQ we need to install appropriate version of Erlang package.
Installing Erlang package

At first we need to download from Erlang Solutions website the appropriate version of esl-erlang for Ubuntu 16.04 (Xenial Xerus). At the time of writing this tutorial, the latest version of this package was the 20.3

After this we run package installation in the directory, where we downloaded the package:

$ sudo dpkg -i esl-erlang_20.3-1~ubuntu~xenial_amd64.deb Selecting previously unselected package esl-erlang.(Reading database ... 62653 files and directories currently installed.)Preparing to unpack esl-erlang_20.3-1~ubuntu~xenial_amd64.deb ...Unpacking esl-erlang (1:20.3) ...dpkg: dependency problems prevent configuration of esl-erlang:[...]

dpkg program is not able to resolve dependencies of esl-erlang, so that we use apt in following way to fix it:

$ sudo apt-get install -f

Then, we will be asked if we want to approve installing additional packages, which will take additional space on out hard drive. Of course we approve it do by pressing Y.

[...]
0 upgraded, 102 newly installed, 0 to remove and 50 not upgraded.
2 not fully installed or removed.
Need to get 64.3 MB of archives.
After this operation, 320 MB of additional disk space will be used.
Do you want to continue? [Y/n] 

After successful installation we go to next step.
Installing RabbitMQ

To automate update process of RabbitMQ server in the future, we add information about repository providing this package to directory /etc/apt/sources.list.d, in which these are stored lists of package repositories processed by apt program.

To achieve that we run following command:

$ echo "deb https://dl.bintray.com/rabbitmq/debian xenial main" | sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list

Next step is getting public key for above package repository:

$ wget -O- https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc | sudo apt-key add -

and then we need to update list of packages and install rabbitmq-server package in common way:

$ sudo apt-get update
$ sudo apt-get install rabbitmq-server

Checking if RabbitMQ is running

To check RabbitMQ server status use following command:

$ sudo service rabbitmq-server status

As a result you should see similar information:

● rabbitmq-server.service - RabbitMQ broker
   Loaded: loaded (/lib/systemd/system/rabbitmq-server.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2018-03-20 12:10:59 UTC; 15s ago
 Main PID: 7146 (beam.smp)
   Status: "Initialized"
   CGroup: /system.slice/rabbitmq-server.service
           ├─7146 /usr/lib/erlang/erts-9.3/bin/beam.smp -W w -A 64 -P 1048576 -t 5000000 -stbt db -zdbbl 1280000 -K true -- -root /usr/lib/erlang -progname erl -- -home /var/lib/rabbitmq
           ├─7223 /usr/lib/erlang/erts-9.3/bin/epmd -daemon
           ├─7366 erl_child_setup 1024
           ├─7390 inet_gethost 4
           └─7391 inet_gethost 4

Mar 20 12:10:57 webs rabbitmq-server[7146]:   ##  ##
Mar 20 12:10:57 webs rabbitmq-server[7146]:   ##  ##      RabbitMQ 3.7.4. Copyright (C) 2007-2018 Pivotal Software, Inc.
Mar 20 12:10:57 webs rabbitmq-server[7146]:   ##########  Licensed under the MPL.  See http://www.rabbitmq.com/
Mar 20 12:10:57 webs rabbitmq-server[7146]:   ######  ##
Mar 20 12:10:57 webs rabbitmq-server[7146]:   ##########  Logs: /var/log/rabbitmq/rabbit@webs.log
Mar 20 12:10:57 webs rabbitmq-server[7146]:                     /var/log/rabbitmq/rabbit@webs_upgrade.log
Mar 20 12:10:57 webs rabbitmq-server[7146]:               Starting broker...
Mar 20 12:10:59 webs rabbitmq-server[7146]: systemd unit for activation check: "rabbitmq-server.service"
Mar 20 12:10:59 webs systemd[1]: Started RabbitMQ broker.
Mar 20 12:11:00 webs rabbitmq-server[7146]:  completed with 0 plugins.

Setting up administration panel

After installing message broker (working on port 5672) we need to set up simple administration panel, which was made by RabbitMQ creators as a plugin. To do so you use following command:

$ sudo rabbitmq-plugins enable rabbitmq_management

Then, to check if administration panel was successfully installed, just enter the following URL in your web browser: http://localhost:15672/

RabbitMQ Management Login Screen

Default login and password is guest.

Guest account is delivered at the beginning of the adventure with RabbitMQ server, but it has one, important limitation: we can use it only with the localhost, so we cannot use it on remote server, where our message broker was installed.

In most cases message sender, message broker and message recipient are located on separate servers.
Adding new administrative account

Because of we can use guest user only on the same server (localhost) we need to create new administrative account. In our case it will be called root, but you can use any name.

At first we create new user root with password top-secret:

$ sudo rabbitmqctl add_user root top-secret

then we assign administrator role to this user:

$ sudo rabbitmqctl set_user_tags root administrator

and at the end we set up vhost and permissions:

$ sudo rabbitmqctl set_permissions -p / root ".*" ".*" ".*"

After that we can log in by using new administrative account RabbitMQ.
