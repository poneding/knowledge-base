[我的知识库](../README.md) / [Kubernetes](zz_gneratered_mdi.md) / local 存储卷实践

# local 存储卷实践

在 Kubernetes 中有一种存储卷类型为 `local`。

`local` 卷所代表的是某个被挂载的本地存储设备，例如磁盘、分区或者目录。

`local` 卷只能用作静态创建的持久卷。不支持动态配置。

与 `hostPath` 卷相比，`local` 卷能够以持久和可移植的方式使用，而无需手动将 Pod 调度到节点。系统通过查看 PersistentVolume 的节点亲和性配置，就能了解卷的节点约束。

然而，`local` 卷仍然取决于底层节点的可用性，并不适合所有应用程序。 如果节点变得不健康，那么 `local` 卷也将变得不可被 Pod 访问。使用它的 Pod 将不能运行。 使用 `local` 卷的应用程序必须能够容忍这种可用性的降低，以及因底层磁盘的耐用性特征而带来的潜在的数据丢失风险。

## 创建 local-storage 存储类

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

## 手动创建 PV/PVC

1、使用 `local` 卷时，你需要设置 PersistentVolume 对象的 `nodeAffinity` 字段。 Kubernetes 调度器使用 PersistentVolume 的 `nodeAffinity` 信息来将使用 `local` 卷的 Pod 调度到正确的节点；

 2、PersistentVolume 对象的 `volumeMode` 字段可被设置为 "Block" （而不是默认值 "Filesystem"），以将 `local` 卷作为原始块设备暴露出来。

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-local-pvc
  namespace: default
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 128Mi
  storageClassName: local-storage
  volumeMode: Filesystem
  volumeName: mysql-local-pv

---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-local-pv
spec:
  capacity:
    storage: 128Mi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  storageClassName: local-storage
  local:
    path: /mysql-data
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - worker-01
```

> ⚠ 注意：
>
> 1、指定亲和节点名称，示例中为 `worker-01`；
>
> 2、指定的节点上需要确保本地目录是存在的，示例中为 `/mysql-data`。

## 创建 Pod

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  selector:
    matchLabels:
      app: mysql
  serviceName: mysql
  replicas: 1
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "123456"
        volumeMounts:
        - name: data
          mountPath: /var/lib/mysql
      restartPolicy: Always
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: mysql-local-pvc
```

## 参考

- <https://kubernetes.io/zh-cn/docs/concepts/storage/volumes/#local>

## lovo 项目

基于 local 存储卷实现一个控制器动态管理 PV。

---
[上篇：Kubernetes 0-1 Pod中的livenessProbe和readinessProbe解读](liveness-readiness-probe.md)

[下篇：Kubernetes 0-1 K8s自建LoadBalancer](metallb.md)
