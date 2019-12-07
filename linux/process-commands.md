
# Linux Server Troubleshooting

Troubleshooting a linux server boils down to the shell after external logs, metrics and monitors have drawn a blank. These commands are the foundation of troubleshoting efforts after you SSH onto the shell.

Resources are the network/bandwidth, drive/disks, RAM/Memory and Process/CPU

| Basic Command         | Valuable Information Gleaned | Symptoms that Warrant this Action | Resource |
|:--------------------- |:---------------------------- |:--------------------------------- |:-------- |



### View Process List by Memory Consumed

**`ps -eo pid,ppid,%mem,%cpu,cmd,start,time --sort=-%mem | head -20`**
**`watch ps -eo pid,ppid,%mem,%cpu,cmd,start,time --sort=-%mem | head -20`**
