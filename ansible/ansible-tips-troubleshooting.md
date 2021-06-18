
# Ansible Tips and Troubleshooting

## copy become only used for destination

A copy **permission denied** error when you've used **`become: true`** is disconcerting.

Until you learn that the copy module only uses elevated permissions on the destination of the copy and not the source.

So if you are trying to read a file (say on a remote host) that the user cannot read, even with become:true - a permissioned denied error still results.

## How to Add /etc/hosts entry to All Nodes

Ansible can add **`/etc/hosts`** entries for every host and if outdated entries already exist it can ammend them. Even better it does not add duplicate entries.

```
---
- name: Add IP address of all hosts to all hosts
  lineinfile:
    dest: /etc/hosts
    regexp: '.*{{ item }}$'
    line: "{{ hostvars[item].ansible_host }} {{item}}"
    state: present
  when: hostvars[item].ansible_host is defined
  with_items: "{{ groups.all }}"
```

If you are not running a DNS server but have a number of hosts to manage alongside a **fickle DHCP allocator**, the above Ansible code can be a godsend.


---

## How to Run commands in isolation

**You can run each task on the command line instead of waiting for the whole playbook to run through before getting feedback.**

This examples copies a file from one place to another on a remote host.

```
ansible <host> -m copy \
    -a "src=/home/ubuntu/pumpkin.txt dest=/home/ubuntu/.kube/new-pumpkin.txt remote_src=yes owner=ubuntu group=docker mode=0644" \
    -i hosts.ini \
    --become-user root
```

