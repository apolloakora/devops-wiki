
# Kubernetes Secrets | kubectl

[[Kubernetes Secrets Official Documentation|https://kubernetes.io/docs/concepts/configuration/secret/]]

## Kubernetes Secrets | List all secrets

kubectl can list every kubernetes secret key and value pair.

```bash
kubectl get secrets
kubectl get secret <<secret-name>> -o yaml | grep ^data -A 1 | tail -n 1 | awk '{ print $2 }' | base64 -d
```

Replace *`<<secret-name>>`* with one of the names given by `kubectl get secrets`.

The oneliner leading with kubectl get secret

- gets the secrets text in yaml format (see below)
- picks out the text under data.app.json
- then base64 decodes it


```yaml
apiVersion: v1
data:
  app.json: abcdefghijklmnopgrstuvwxyz0123456789inbase64==
kind: Secret
metadata:
  creationTimestamp: 2018-09-05T19:34:23Z
  name: <<secret-name>>
  namespace: default
  resourceVersion: "1234345"
  selfLink: /api/v1/namespaces/default/secrets/<<secret-name>>
  uid: 12341234-1234-1234-12341234123412341234
type: Opaque
```

## Kubernetes Secrets | Set secret | Update secret

This is how to set or update a Kubernetes secret.

```bash
echo -n 'secret123' | base64      # Convert the secret to a base64 format
```

