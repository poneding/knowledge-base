[我的知识库](../README.md) / [kubernetes](zz_gneratered_mdi.md) / apiserver-builder

# apiserver-builder

## 安装

```bash
go install sigs.k8s.io/apiserver-builder-alpha/cmd/apiserver-boot@v1.23.0
```

## 搭建

**初始化项目**：

⚠️ 注意：由于历史原因需要进入 `$(go env GOPATH)/src/<package>` 包目录下执行初始化命令。

```bash
mkdir -p $(go env GOPATH)/src/github.com/poneding/apiserver-demo && cd $(go env GOPATH)/src/github.com/poneding/apiserver-demo
apiserver-boot init repo --domain k8sdev.poneding.com
```

**创建 API**：

```bash
# apiserver-boot create <group> <version> <resource>
apiserver-boot create demo v1alpha1 User
apiserver-boot create group version resource --group demo --version v1alpha1 --kind User
```

## 参考

- <https://github.com/kubernetes-sigs/apiserver-builder-alpha/blob/master/docs/tools_user_guide.md>
- <https://github.com/kubernetes-sigs/apiserver-builder-alpha/blob/master/README.md>

---
[上篇：反亲和性提高服务可用性](anti-affinity-improves-service-availability.md)

[下篇：apiserver](apiserver.md)
