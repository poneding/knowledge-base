[我的知识库](../../README.md) / [Kubernetes](../zz_generated_mdi.md) / [KubeVirt](zz_generated_mdi.md) / 制作虚拟机容器镜像

# 制作虚拟机容器镜像

以制作 `ubuntu 22.04` 虚拟机容器镜像为例。

准备 *Dockerfile* 文件，内容如下：

```dockerfile
FROM scratch

ARG TARGETARCH
ADD --chown=107:107 https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-${TARGETARCH}.img /disk/
```

编译镜像：

```bash
docker buildx build --push --platform linux/amd64,linux/arm64 . -t poneding/container-disk-ubuntu:22.04
```
---
[« Kubevirt 实践](kubevirt-practice.md)

[» Kubevirt 安装 windows-server-2022](windows.md)
