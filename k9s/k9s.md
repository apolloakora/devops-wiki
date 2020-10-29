
# k9s | Manage Kubernetes Clusters

k9s is a cool kubernetes explorer and is quicker by far than kubectl (although its feature set isn't as yet overwhelming). To shell into a pod's command line you type **`k9s`**, scroll to the pod and then **`s`** to drop into the shell. It beats typing in this kubectl command.

```
kubectl exec -it `kubectl get pods --output name | grep --max-count=1 <pod-name-prefix> | cut -d / -f 2` -- /bin/bash
```

## Install k9s on MacOSx

```
brew install k9s
```

## Working with Kubernetes namespaces

```
k9s --namespace <namespace> # enter a single namespace
k9s                         # access all namespaces
```

### Jump to Namespaces

Look at the top bar and you'll see your namesspaces numbered so

- **`0`** - view all pods in all namespaces
- **`1`** - view pods in <this> namespace
- **`2`** - view pods in <default> namespace (if you have only 2 namespaces)





## Commands inside k9s

- **`0`** - zero will show all pods in all namespaces
- **`d`** - describe the selected pod
- **`l`** or **`[Enter]`** will show all logs for pod
- **`:svc`** - jump to a **services** view
- **`:deploy`** - jump to a **deployment** view
- **`:rb`** - jump to a **role bindings** (RBAC) view
- **`:namespace`** - jump back to the namespaces view
- **`:cj`** - jump to a **cronjobs** view
- **`esc`** - escape up one level
- **`ctrl-d`** - delete pods, deployments, stateful sets and secrets
- **``**
- **``**
- **``**
- **``**


## k9s on the internets

- **[Great k9s YouTube Video](https://youtu.be/k7zseUhaXeU)**



```
RESOURCE                                                           GENERAL                                                                 NAVIGATION                                                         HELP                                                           │
│ <0>                            all                                 <esc>                              Back/Clear                           <j>                              Down                              <ctrl-a>                       Aliases                         │
│ <1>                            default                             <ctrl-u>                           Command Clear                        <shift-g>                        Goto Bottom                       <?>                            Help                            │
│ <c>                            Copy                                <:cmd>                             Command mode                         <g>                              Goto Top                                                                                         │
│ <ctrl-d>                       Delete                              <tab>                              Field Next                           <h>                              Left                                                                                             │
│ <d>                            Describe                            <backtab>                          Field Previous                       <ctrl-f>                         Page Down                                                                                        │
│ <e>                            Edit                                </term>                            Filter mode                          <ctrl-b>                         Page Up                                                                                          │
│ <?>                            Help                                <space>                            Mark                                 <l>                              Right                                                                                            │
│ <ctrl-r>                       Refresh                             <ctrl-\>                           Mark Clear                           <k>                              Up                                                                                               │
│ <shift-a>                      Sort Age                            <ctrl-space>                       Mark Range                                                                                                                                                             │
│ <shift-n>                      Sort Name                           <:q>                               Quit                                                                                                                                                                   │
│ <ctrl-z>                       Toggle Faults                       <ctrl-r>                           Reload                                                                                                                                                                 │
│ <ctrl-w>                       Toggle Wide                         <ctrl-s>                           Save                                                                                                                                                                   │
│ <enter>                        View                                <ctrl-e>                           Toggle Header
```
