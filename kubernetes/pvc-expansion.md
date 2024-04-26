[我的知识库](../README.md) / [Kubernetes](zz_generated_mdi.md) / PVC 扩容

# PVC 扩容

K8s 部署的 Kafka 程序突然挂了，查看相关日志发现原来是挂日志的磁盘空间不足，那么现在需要对磁盘进行扩容。

使用以下命令执行 PVC 扩容的操作：

```bash
kubectl edit pvc <pvc-name> -n <namespace>
```

执行过程中发现，无法对该 PVC 进行动态扩容，需要分配 PVC 存储的 StorageClass 支持动态扩容。

![image-20200905152418894](https://fs.poneding.com/images/image-20200905152418894.png)

那么怎么是的 StorageClass 支持动态扩容呢，很简单，更新 StorageClass 即可。

```bash
kubectl edit storageclass <storageclass-name>
```

添加属性：

```tex
allowVolumeExpansion: true # 允许卷扩充
```

之后再次执行 PVC 扩容的操作即可。

---
[« Prometheus](prometheus.md)

[» 了解 Secret](secret-understood.md)
