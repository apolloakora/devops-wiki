

## Copy the Linux Oracle Zip File to the Machine

scp -C -i ~/.ssh/app2-private-key.pem LINUX.X64_180000_db_home.zip app2@40.120.43.126:~/LINUX.X64_180000_db_home.zip




## Clone Project from Oracle's Docker Account

git clone https://github.com/oracle/docker-images oracle.docker




## Goto the Oracle Dockerfile directory

cd oracle.docker/OracleDatabase/SingleInstance/dockerfiles/18.3.0






## Perform the Oracle Image Docker Build

sudo docker build -t oracle:18.3.0 --build-arg DB_EDITION=EE .





## Run the Oracle Database

docker run -d -it --name vm.oracle --restart always --publish 1521:1521 oracle:18.3.0
docker ps -a




## Discover the Login Details

#### Wait for 5 to 10 minutes

Keep running the command **`docker logs oracle18`** to watch for the below ready to use banner.




## Setup Oracle SysDBA

This command verifies that the database identified by the **`ORCLPDB1`** service identifier (SID) is up and running plus the password you have enterd for the sys user is the correct one.

- **`ORACLE_SID=ORCLPDB1; export ORACLE_SID; sqlplus sys as sysdba`**





The above sql plus command asks for the password (we should find a way to pass it in). We can try these to pass in password
```
sqlplus username/password as sysdba
sqlplus sys/pIKontCErpI=1 as sysdba
```


## Running a bunch of scripts

Copy zip to machine
unzip it
chmod u+x main-script.sh
./main-acript <<PASSWORD>>








## To run an individual script try this

```
sqlplus sys/pIKontCErpI=1 as sysdba  @/path/to/the/file.sql
```

or run sqlplus from the folder

```
sqlplus sys/pIKontCErpI=1 as sysdba  @/path/to/the/file.sql
```








##
## sqlplus sys/pIKontCErpI=1 as sysdba drop  @/path/to/the/file.sql


docker cp /home/apollo/assets/trinity.projects/poc-database/SQL/schema_setup.sql oracle18:/home/oracle/schema_setup.sql
docker cp /home/apollo/assets/trinity.projects/poc-database/SQL/remove_triggers.sql oracle18:/home/oracle/remove_triggers.sql

docker exec -it oracle18 ls -lah



docker exec -it oracle18 sqlplus sys/pIKontCErpI=1@ORCLPDB1 as sysdba  @schema_setup.sql


apollo@trafalgar:~/assets/oracle.docker/OracleDatabase/SingleInstance/dockerfiles/18.3.0$ docker exec -it oracle18 sqlplus sys/pIKontCErpI=1@ORCLPDB1 as sysdba

SQL*Plus: Release 18.0.0.0.0 - Production on Thu Nov 14 18:46:44 2019
Version 18.3.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.


Connected to:
Oracle Database 18c Enterprise Edition Release 18.0.0.0.0 - Production
Version 18.3.0.0.0

SQL> select owner, object_name from all_objects where owner in ('LEDGER');
select owner, object_name from all_objects where owner in ('LEDGER');




Database Url => 
Database Port => 1521
Database Name (SID) => ORCLPDB1
Database Username => ledger
Database Password => poc

Database Url => 
Database Port => 1521
Database Name (SID) => ORCLPDB1
Database Username => message
Database Password => poc




docker exec -it oracle18 sqlplus sys/pIKontCErpI=1@ORCLCDB as sysdba

drop tablespace ts_ledger_idx cascade;




ORCLCDB





SQL> exit
exit
Disconnected from Oracle Database 18c Enterprise Edition Release 18.0.0.0.0 - Production
Version 18.3.0.0.0
apollo@trafalgar:~/assets/oracle.docker/OracleDatabase/SingleInstance/dockerfiles/18.3.0$ 
apollo@trafalgar:~/assets/oracle.docker/OracleDatabase/SingleInstance/dockerfiles/18.3.0$ docker exec -it oracle18 sqlplus sys/pIKontCErpI=1@ORCLCDB as sysdba

SQL*Plus: Release 18.0.0.0.0 - Production on Thu Nov 14 18:44:29 2019
Version 18.3.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.


Connected to:
Oracle Database 18c Enterprise Edition Release 18.0.0.0.0 - Production
Version 18.3.0.0.0

SQL> drop tablespace ts_ledger_idx;
drop tablespace ts_ledger_idx;

Tablespace dropped.

SQL> drop tablespace ts_ledger_tbl;
drop tablespace ts_ledger_tbl;

Tablespace dropped.

SQL> drop tablespace ts_message_idx;
drop tablespace ts_message_idx;

Tablespace dropped.

SQL> drop tablespace ts_message_tbl;
drop tablespace ts_message_tbl;

Tablespace dropped.



```
#########################
DATABASE IS READY TO USE!
#########################
```

Once the banner appears you can look at the logs to find
- the password (like **`uICgwPb4FpY=1`**)
- the database name (like **`ORCLCDB`**)
- the SID or system identifider (like **`ORCLCDB`**)

### Docker Oracle Logs | Example

```
ORACLE PASSWORD FOR SYS, SYSTEM AND PDBADMIN: 5wcH20Tewmg=1

LSNRCTL for Linux: Version 18.0.0.0.0 - Production on 07-NOV-2019 12:15:56

Copyright (c) 1991, 2018, Oracle.  All rights reserved.

Starting /opt/oracle/product/18c/dbhome_1/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 18.0.0.0.0 - Production
System parameter file is /opt/oracle/product/18c/dbhome_1/network/admin/listener.ora
Log messages written to /opt/oracle/diag/tnslsnr/99fd8dd94b02/listener/alert/log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1)))
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 18.0.0.0.0 - Production
Start Date                07-NOV-2019 12:15:56
Uptime                    0 days 0 hr. 0 min. 0 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/oracle/product/18c/dbhome_1/network/admin/listener.ora
Listener Log File         /opt/oracle/diag/tnslsnr/99fd8dd94b02/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))
The listener supports no services
The command completed successfully
Prepare for db operation
8% complete
Copying database files
31% complete
Creating and starting Oracle instance
32% complete
36% complete
40% complete
43% complete
46% complete
Completing Database Creation
51% complete
54% complete
Creating Pluggable Databases
58% complete
77% complete
Executing Post Configuration Actions
100% complete
Database creation complete. For details check the logfiles at:
 /opt/oracle/cfgtoollogs/dbca/ORCLCDB.
Database Information:
Global Database Name:ORCLCDB
System Identifier(SID):ORCLCDB
Look at the log file "/opt/oracle/cfgtoollogs/dbca/ORCLCDB/ORCLCDB.log" for further details.

SQL*Plus: Release 18.0.0.0.0 - Production on Thu Nov 7 12:30:52 2019
Version 18.3.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.


Connected to:
Oracle Database 18c Enterprise Edition Release 18.0.0.0.0 - Production
Version 18.3.0.0.0

SQL> 
System altered.

SQL> 
System altered.

SQL> 
Pluggable database altered.

SQL> 
PL/SQL procedure successfully completed.

SQL> Disconnected from Oracle Database 18c Enterprise Edition Release 18.0.0.0.0 - Production
Version 18.3.0.0.0
The Oracle base remains unchanged with value /opt/oracle
#########################
DATABASE IS READY TO USE!
#########################
The following output is now a tail of the alert.log:
ORCLPDB1(3):CREATE SMALLFILE TABLESPACE "USERS" LOGGING  DATAFILE  '/opt/oracle/oradata/ORCLCDB/ORCLPDB1/users01.dbf' SIZE 5M REUSE AUTOEXTEND ON NEXT  1280K MAXSIZE UNLIMITED  EXTENT MANAGEMENT LOCAL  SEGMENT SPACE MANAGEMENT  AUTO
ORCLPDB1(3):Completed: CREATE SMALLFILE TABLESPACE "USERS" LOGGING  DATAFILE  '/opt/oracle/oradata/ORCLCDB/ORCLPDB1/users01.dbf' SIZE 5M REUSE AUTOEXTEND ON NEXT  1280K MAXSIZE UNLIMITED  EXTENT MANAGEMENT LOCAL  SEGMENT SPACE MANAGEMENT  AUTO
ORCLPDB1(3):ALTER DATABASE DEFAULT TABLESPACE "USERS"
ORCLPDB1(3):Completed: ALTER DATABASE DEFAULT TABLESPACE "USERS"
2019-11-07T12:30:52.554226+00:00
ALTER SYSTEM SET control_files='/opt/oracle/oradata/ORCLCDB/control01.ctl' SCOPE=SPFILE;
2019-11-07T12:30:52.565026+00:00
ALTER SYSTEM SET local_listener='' SCOPE=BOTH;
   ALTER PLUGGABLE DATABASE ORCLPDB1 SAVE STATE
Completed:    ALTER PLUGGABLE DATABASE ORCLPDB1 SAVE STATE
```



######################################################################################################################################
######################################################################################################################################
######################################################################################################################################
######################################################################################################################################
######################################################################################################################################
######################################################################################################################################
######################################################################################################################################




 docker exec -it oracle18 /bin/bash
^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ 

^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ 

[oracle@76b18cc7ce9c ~]$ 

^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ 

^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ 

^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ sqlplus sys as sysdba
sqlplus sys as sysdba

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Nov 22 19:00:38 2019
Version 18.3.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Enter password:
ERROR:
ORA-12162: TNS:net service name is incorrectly specified


Enter user-name: ORCLPDB1
ORCLPDB1
Enter password:
ERROR:
ORA-12162: TNS:net service name is incorrectly specified


Enter user-name: ^C
^C
^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ 

^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ 




^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ sqlplus sys as sysdba
sqlplus sys as sysdba

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Nov 22 19:01:56 2019
Version 18.3.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Enter password:
ERROR:
ORA-12162: TNS:net service name is incorrectly specified


Enter user-name: 

ERROR:
ORA-12162: TNS:net service name is incorrectly specified


Enter user-name: 

ERROR:
ORA-12162: TNS:net service name is incorrectly specified


SP2-0157: unable to CONNECT to ORACLE after 3 attempts, exiting SQL*Plus
^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ 




]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ ORACLE_SID=ORCLPDB1; export ORACLE_SID
ORACLE_SID=ORCLPDB1; export ORACLE_SID
^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ sqlplus sys as sysdba
sqlplus sys as sysdba

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Nov 22 19:05:09 2019
Version 18.3.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Enter password:
Connected to an idle instance.

SQL> exit
exit
Disconnected
[oracle@76b18cc7ce9c ~]$ ls -l
ls -l
total 0
lrwxrwxrwx 1 root root 26 Nov 22 17:59 setPassword.sh -> /opt/oracle/setPassword.sh
^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ pwd
pwd
/home/oracle
^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ ls -l
ls -l
total 8
-rw-rw-r-- 1 1000 1000 7138 Nov 22 19:19 schema_setup.zip
lrwxrwxrwx 1 root root   26 Nov 22 17:59 setPassword.sh -> /opt/oracle/setPassword.sh
^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ mkdir schema_setup
mkdir schema_setup
^[]0;@76b18cc7ce9c:~^G[oracle@76b18cc7ce9c ~]$ cd schema_setup
cd schema_setup
^[]0;@76b18cc7ce9c:~/schema_setup^G[oracle@76b18cc7ce9c schema_setup]$ unzip ../schema_setup.zip
unzip ../schema_setup.zip
Archive:  ../schema_setup.zip
  inflating: ledger.sql
  inflating: ledger_sys.sql
  inflating: ledger2.sql
  inflating: ledger2_sys.sql
  inflating: message.sql


[]0;@76b18cc7ce9c:~/schema_setup^G[oracle@76b18cc7ce9c schema_setup]$ chmod u+x temp_schema_setup.sh
chmod u+x temp_schema_setup.sh
^[]0;@76b18cc7ce9c:~/schema_setup^G[oracle@76b18cc7ce9c schema_setup]$ ls -l
ls -l
total 40
-rw-r--r-- 1 oracle oinstall 5941 Nov 22 16:43 ledger.sql
-rw-r--r-- 1 oracle oinstall 5961 Nov 22 16:53 ledger2.sql
-rw-r--r-- 1 oracle oinstall  943 Nov 22 16:53 ledger2_sys.sql
-rw-r--r-- 1 oracle oinstall 2712 Nov 20 12:13 ledger_sys.sql
-rw-r--r-- 1 oracle oinstall 8023 Nov 22 17:09 message.sql
-rw-r--r-- 1 oracle oinstall 2684 Nov 20 12:14 message_sys.sql
-rwxr--r-- 1 oracle oinstall  305 Nov 22 17:20 temp_schema_setup.sh
^[]0;@76b18cc7ce9c:~/schema_setup^G[oracle@76b18cc7ce9c schema_setup]$ ./temp_schema_setup.sh tTEVhp2PYCA=1
./temp_schema_setup.sh tTEVhp2PYCA=1
./temp_schema_setup.sh: line 2: $'\r': command not found

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Nov 22 19:21:59 2019
Version 18.3.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> CREATE TABLESPACE ts_ledger_idx DATAFILE
*
ERROR at line 1:
ORA-01034: ORACLE not available
Process ID: 0
Session ID: 0 Serial number: 0


CREATE TABLESPACE ts_ledger_tbl DATAFILE
*
ERROR at line 1:
ORA-01034: ORACLE not available
Process ID: 0
Session ID: 0 Serial number: 0




SP2-0306: Invalid option.
Usage: CONN[ECT] [{logon|/|proxy} [AS {SYSDBA|SYSOPER|SYSASM|SYSBACKUP|SYSDG|SYSKM|SYSRAC}] [edition=value]]
where <logon> ::= <username>[/<password>][@<connect_identifier>]
      <proxy> ::= <proxyuser>[<username>][/<password>][@<connect_identifier>]
SP2-0157: unable to CONNECT to ORACLE after 3 attempts, exiting SQL*Plus
./temp_schema_setup.sh: line 14: $'\r': command not found

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Nov 22 19:22:00 2019
Version 18.3.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

ERROR:
ORA-01034: ORACLE not available
ORA-27101: shared memory realm does not exist
Linux-x86_64 Error: 2: No such file or directory
Additional information: 4150
Additional information: 1815269875
Process ID: 0
Session ID: 0 Serial number: 0


Enter user-name: ERROR:
ORA-01017: invalid username/password; logon denied





rw-r--r-- 1 oracle oinstall 8023 Nov 22 17:09 message.sql
-rw-r--r-- 1 oracle oinstall 2684 Nov 20 12:14 message_sys.sql
-rwxr--r-- 1 oracle oinstall  305 Nov 22 17:20 temp_schema_setup.sh
^[]0;@76b18cc7ce9c:~/schema_setup^G[oracle@76b18cc7ce9c schema_setup]$ sed -i 's/\r//g' temp_schema_setup.sh
sed -i 's/\r//g' temp_schema_setup.sh
^[]0;@76b18cc7ce9c:~/schema_setup^G[oracle@76b18cc7ce9c schema_setup]$ 

^[]0;@76b18cc7ce9c:~/schema_setup^G[oracle@76b18cc7ce9c schema_setup]$ 

^[]0;@76b18cc7ce9c:~/schema_setup^G[oracle@76b18cc7ce9c schema_setup]$ ./temp_schema_setup.sh tTEVhp2PYCA=1
./temp_schema_setup.sh tTEVhp2PYCA=1

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Nov 22 19:26:24 2019
Version 18.3.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> CREATE TABLESPACE ts_ledger_idx DATAFILE
*
ERROR at line 1:
ORA-01034: ORACLE not available
Process ID: 0
Session ID: 0 Serial number: 0


CREATE TABLESPACE ts_ledger_tbl DATAFILE
*
ERROR at line 1:
ORA-01034: ORACLE not available
Process ID: 0
Session ID: 0 Serial number: 0


CREATE USER ledger IDENTIFIED BY poc
*
ERROR at line 1:
ORA-01034: ORACLE not available
Process ID: 0
Session ID: 0 Serial number: 0




[]0;@76b18cc7ce9c:~/schema_setup^G[oracle@76b18cc7ce9c schema_setup]$ ORACLE_SID=ORCLPDB1; export ORACLE_SID
ORACLE_SID=ORCLPDB1; export ORACLE_SID
^[]0;@76b18cc7ce9c:~/schema_setup^G[oracle@76b18cc7ce9c schema_setup]$ sqlplus sys as sysdba
sqlplus sys as sysdba

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Nov 22 19:29:36 2019
Version 18.3.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Enter password:
Connected to an idle instance.

SQL> startup 
startup
ORA-01078: failure in processing system parameters
LRM-00109: could not open parameter file '/opt/oracle/product/18c/dbhome_1/dbs/initORCLPDB1.ora'
SQL> exit
exit
Disconnected
^[]0;@76b18cc7ce9c:~/schema_setup^G[oracle@76b18cc7ce9c schema_setup]$ printenv
printenv
CONFIG_RSP=dbca.rsp.tmpl
INSTALL_RSP=db_inst.rsp
HOSTNAME=76b18cc7ce9c
TERM=xterm
INSTALL_DIR=/opt/install
OLDPWD=/home/oracle
LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=\
01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01\
;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.\
xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wm\
v=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:\
*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:
LD_LIBRARY_PATH=/opt/oracle/product/18c/dbhome_1/lib:/usr/lib
ORACLE_SID=ORCLPDB1
SETUP_LINUX_FILE=setupLinuxEnv.sh
CHECK_DB_FILE=checkDBStatus.sh
INSTALL_FILE_1=LINUX.X64_180000_db_home.zip
ORACLE_BASE=/opt/oracle





