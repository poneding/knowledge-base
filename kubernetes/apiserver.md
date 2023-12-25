[我的知识库](../README.md) / [kubernetes](zz_gneratered_mdi.md) / apiserver

# apiserver

每一个 api 版本均有一个 apiservice 与之对应

```bash
k api-versions | wc -l
 30
k get apiservices.apiregistration.k8s.io| wc -l
 30
```

---
[上篇：apiserver-builder](apiserver-builder.md)

[下篇：二进制搭建 K8s - 1 机器准备](binary-build-k8s-01-prepare-nodes.md)
