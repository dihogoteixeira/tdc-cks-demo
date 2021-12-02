# CRIANDO DUAS SECRETS E MONTANDO UTILIZANDO NO POD 

```sh
kubectl create secret generic secret1 --from-literal user=admin
kubectl create secret generic secret2 --from-literal pass=123456789
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.secret.yaml
```

***secret1 using as file-from-a-pod (mount fs)***
[https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod)

***secret2 using as env (env var)***
[https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-environment-variables](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-environment-variables)

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    resources: {}
    env:
      - name: PASSWORD
        valueFrom:
          secretKeyRef:
            name: secret2
            key: pass
    volumeMounts:
    - name: secret1
      mountPath: "/etc/secret1"
      readOnly: true
  volumes:
  - name: secret1
    secret:
      secretName: secret1
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
```

```sh
kubectl create -f pod.secret.yaml
```

# VALIDANDO ENV
```sh
kubectl get pod
kubectl exec pod -- env |grep PASS
```

# VALIDANDO SECRET MOUNT FS
```sh
kubectl exec pod -- mount |grep secret1
kubectl exec pod -- find /etc/secret1
kubectl exec pod -- find /etc/secret1/user
```

# EXPLORANDO SECRETS CONTAINER RUNTIME on Node
```sh
crictl ps
crictl inspect <container_id>
crictl inspect <container_id> | vim -
/pid
ps aux |grep <filesystem_pid>
ls /proc/<filesystem_pid>/root/
find /proc/<filesystem_pid>/root/etc/secret1
cat /proc/<filesystem_pid>/root/etc/secret1/user
crictl inspect <container_id> |grep PASSWORD
```

# EXPLORANDO SECRETS NO ETCD on MASTER
```sh
ETCDCTL_API=3 etcdctl endpoint health #failed
```

`access secret int etcd`
```sh
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd

ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt
  --key /etc/kubernetes/pki/apiserver-etcd-client.key
  --cacert /etc/kubernetes/pki/etcd/ca.crt endpoint health
```

***--endpoints "https://127.0.0.1:2379" not necessary because we’re on same node***
```sh
ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt
  --key /etc/kubernetes/pki/apiserver-etcd-client.key
  --cacert /etc/kubernetes/pki/etcd/ca.crt
  get /registry/secrets/default/secret1
```

```sh
ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt
  --key /etc/kubernetes/pki/apiserver-etcd-client.key
  --cacert /etc/kubernetes/pki/etcd/ca.crt
  get /registry/secrets/default/secret2
```

---

#### Encryption etdc from MASTER NODE
##### Encryption etcd k8s doc
[https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)
```sh
cd /etc/kubernetes/
mkdir etcd
vim ec.yaml
```

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - aescbc:
        keys:
        - name: key1
          secret: c2VjdXJlcGFzc3dvcmQ=
    - identity: {}
```

```sh
echo -n securepassword | base64
# c2VjdXJlcGFzc3dvcmQ=
```

```sh
cd ../manifests/
vim kube-adminserver.yaml
```

[encrypt-data/#configuration](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#configuration-and-determining-whether-encryption-at-rest-is-already-enabled "encrypt-data/#configuration")
```yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 187.109.79.100:6443
  creationTimestamp: null
  labels:
    component: kube-apiserver
    tier: control-plane
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    - --encryption-provider-config=/etc/kubernetes/etcd/ec.yaml # ADD COMMAND
...
    volumeMounts: # ADD VOLUMEMOUNTS
    - mountPath: /etc/kubernetes/etcd
      name: etcd
      readOnly: true
...
  volumes: # ADD VOLUMES
  - hostPath:
      path: /etc/kubernetes/etcd
      type: DirectoryOrCreate
    name: etcd
```

***RESTART APISERVER***
```sh
cd /etc/kubernetes/manifests
mv kube-apiserver.yaml ..
mv ../kube-apiserver.yaml .
ps aux |grep apiserver
cd /var/log/pods/
l
tail -f kube-system_kube-apiserver-<hostname_master>_id/kube-apiserver/<id>.log
kubectl get secrets
```

```sh
kubectl get secret <secret_name> -o yaml
```

```sh
ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt
  --key /etc/kubernetes/pki/apiserver-etcd-client.key
  --cacert /etc/kubernetes/pki/etcd/ca.crt
  get /registry/secrets/default/<secret_name>
```

```sh
kubectl create secret generic ec-secret1 --from-literal cpf=365234554324
```

```sh
ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt
  --key /etc/kubernetes/pki/apiserver-etcd-client.key
  --cacert /etc/kubernetes/pki/etcd/ca.crt
  get /registry/secrets/default/ec-secret1
```

```sh
kubectl get secret ec-secret1 -o yaml
```

```sh
echo MTIzNA== | base64 -d
```

```sh
kubectl delete secret default-token-<sha_id> 
```

```sh
kubectl get secret default-token-<sha_id> -o yaml
```

```sh
ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt
  --key /etc/kubernetes/pki/apiserver-etcd-client.key
  --cacert /etc/kubernetes/pki/etcd/ca.crt
  get /registry/secrets/default/default-token-<sha_id>
```

```sh
cd /etc/kubernetes/etcd
vim ec.yaml
```

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - aescbc:
        keys:
        - name: key1
          secret: c2VjdXJlcGFzc3dvcmQ=
#COMENTE  - identity: {} 
```

***RESTART APISERVER***
```sh
cd /etc/kubernetes/manifests
mv kube-apiserver.yaml ..
mv ../kube-apiserver.yaml .
ps aux | grep apiserver
kubectl get secrets
kubectl get secrets -o yaml
```

```sh
kubectl get secret -n kube-system
```

```sh
cd /etc/kubernetes/etcd
vim ec.yaml
```

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - aescbc:
        keys:
        - name: key1
          secret: c2VjdXJlcGFzc3dvcmQ=
    - identity: {} #DESCOMENTE
```

***RESTART APISERVER***
```sh
cd /etc/kubernetes/manifests
mv kube-apiserver.yaml ..
mv ../kube-apiserver.yaml .
ps aux | grep apiserver
kubectl get -n kube-system secrets
```

```sh
kubectl get secrets --all-namespaces -o yaml | kubectl replace -f -
kubectl get secrets -n kube-system <secret_name> -o yaml

ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt
  --key /etc/kubernetes/pki/apiserver-etcd-client.key
  --cacert /etc/kubernetes/pki/etcd/ca.crt
  get /registry/secrets/kube-system/<secret_name>
```

**RECAP**

[providers](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#providers "providers")

Encrypting your data with the [KMS](https://kubernetes.io/docs/tasks/administer-cluster/kms-provider/#encrypting-your-data-with-the-kms-provider "KMS") provider

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - secrets
    providers:
      - kms:
          name: myKmsPlugin
          endpoint: unix:///tmp/socketfile.sock
          cachesize: 100
          timeout: 3s
      - identity: {}
```