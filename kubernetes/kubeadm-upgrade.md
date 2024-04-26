[我的知识库](../README.md) / [Kubernetes](zz_generated_mdi.md) / Kubeadm 升级 K8s

# Kubeadm 升级 K8s

本篇以升级 1.29.0（旧版本：1.28.x ） 版本为例，介绍如何通过 kubeadm 工具来升级 K8s 集群。

> 注意：
>
> 1. 不支持跨主版本升级，如 1.27.x 升级到 1.29.x，中间必须先升级到 1.28.x
> 2. 主版本更新必须先升级到最新的次版本，如 1.28.3 升级到 1.28.4，然后再升级到 1.29.x

## 升级步骤

1. 控制节点（control plane node）升级
2. 工作节点（worker node）升级

## 升级过程

### 1、升级至当前主版本的最新次版本

```bash
sudo apt update
sudo apt-cache madison kubeadm
```

以上命令后，将可以得到类似如下输出：

```bash
$ sudo apt-cache madison kubeadm

   kubeadm | 1.28.4-1.1 | https://pkgs.k8s.io/core:/stable:/v1.28/deb  Packages
   kubeadm | 1.28.3-1.1 | https://pkgs.k8s.io/core:/stable:/v1.28/deb  Packages
   kubeadm | 1.28.2-1.1 | https://pkgs.k8s.io/core:/stable:/v1.28/deb  Packages
   kubeadm | 1.28.1-1.1 | https://pkgs.k8s.io/core:/stable:/v1.28/deb  Packages
   kubeadm | 1.28.0-1.1 | https://pkgs.k8s.io/core:/stable:/v1.28/deb  Packages
```

确定当前主版本的最新次版本为 `1.28.4-1.1`，然后执行以下命令（控制节点上执行）：

```bash
export VERSION=1.28.4-1.1
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm=$VERSION && \
sudo apt-mark hold kubeadm

sudo kubeadm version
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v$(echo $VERSION | cut -d'-' -f1)
```

> 其他节点升级，最后一步执行 `sudo kubeadm upgrade node` 命令。

升级 kubectl、kubelet：

如果集群包括多个节点，那么在升级单个节点上的 kubelet 服务前，最好先将当前节点置为不可调度状态，并且将其上的 Pod 驱逐到其他节点上。

```bash
kubectl drain [current-node] --ignore-daemonsets
```

等待当前节点上的 Pod 驱逐完成后，再升级 kubelet 服务。升级完成后，再将当前节点置为可调度状态。

```bash
kubectl uncordon [current-node]
```

执行一下命令，升级 kubectl、kubelet 组件：

```bash
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet=$VERSION kubectl=$VERSION && \
sudo apt-mark hold kubelet kubectl

# 重启 kubelet 服务
sudo systemctl daemon-reload
sudo systemctl restart kubelet.service
```

### 2、升级至下一个主版本

修改 `/etc/apt/sources.list.d/kubernetes.list` 文件，将 `1.28` 改为 `1.29`：

```bash
sudo sed -i 's/1.28/1.29/g' /etc/apt/sources.list.d/kubernetes.list
```

然后参照上面的步骤，升级集群到下一个主版本 v1.29.x。

## 参考

- [Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)

---
[« kubeadm 安装 k8s (containerd)](kubeadm-install-k8s.md)

[» kubebuilder 实战](kubebuilder-inaction.md)
