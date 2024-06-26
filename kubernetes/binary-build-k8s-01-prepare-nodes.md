[我的知识库](../README.md) / [Kubernetes](zz_generated_mdi.md) / 二进制搭建 K8s - 1 机器准备

# 二进制搭建 K8s - 1 机器准备

## 写在前面

记录和分享使用二进制搭建 K8s 集群的详细过程，由于操作比较冗长，大概会分四篇写完：

1. **[机器准备](./binary-build-k8s-01-prepare-nodes.md)**：
2. **[部署 etcd 集群](./binary-build-k8s-02-deploy-etcd.md)**：
3. **[部署 Master](./binary-build-k8s-03-deploy-master.md)**：
4. **[部署 Node](./binary-build-k8s-04-deploy-worker.md)**：

整个目标是使用二进制的方式搭建一个小型 K8s 集群（1 个 Master，2 个 Node），供自己学习测试。

至于为什么要自己去用二进制的方式去搭建 K8s，而不是选用 minikube 或者 kubeadm 去搭建？

因为使用二进制搭建，K8s 的每个组件，每个工具都需要你手动的安装和配置，帮助你加深对 K8s 组织架构和工作原理的了解。

## 准备工作

三台 centos7 虚拟机，自己学习使用的话 1 核 1G 应该就够了。

虚拟机能够连网，相关的安装包文件下载和 Docker 下载镜像需要使用到外网。

当前虚拟机：

- k8s-master01: 192.168.115.131
- k8s-node01: 192.168.115.132
- k8s-node02: 192.168.115.133

## 虚拟机初始化

不做特殊说明的话：

- 以下操作需要在 Master 和 Node 的所有机器上执行

- 使用 sudo 权限执行命令

### 配置网络接口

```shell
# 使用 ip addr 获取不到机器的 IP 时执行 dhclient  命令
dhclient
```

### 安装基础软件

```shell
yum install vim ntp wget -y
```

### 修改主机名并添加 hosts

在k8s-master01上执行

```shell
hostnamectl set-hostname "k8s-master01"
```

在k8s-node01上执行

```shell
hostnamectl set-hostname "k8s-node01"
```

在k8s-node02上执行

```shell
hostnamectl set-hostname "k8s-node02"
```

### 添加 hosts

```shell
vim /etc/hosts
```

执行上行命令，在文件中追加以下内容：

```tex
192.168.115.131 k8s-master01
192.168.115.132 k8s-node01
192.168.115.133 k8s-node02
```

### 关闭防火墙、selinux、swap

```shell
systemctl stop firewalld
systemctl disable firewalld

setenforce 0
sed -i 's/enforcing/disabled/' /etc/selinux/config

swapoff -a
vim /etc/fstab
# 编辑 etc/fstab 文件，注释 swap 所在的行
```

### 同步时间

```shell
ntpdate time.windows.com
```

### Master 准备文件

在 Master 机器执行：

```bash
mkdir /root/kubernetes/resources -p
cd /root/kubernetes/resources
wget https://dl.k8s.io/v1.18.3/kubernetes-server-linux-amd64.tar.gz
wget https://github.com/etcd-io/etcd/releases/download/v3.4.9/etcd-v3.4.9-linux-amd64.tar.gz
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

### Node 准备文件

在 Node 机器执行：

```bash
mkdir /root/kubernetes/resources -p
cd /root/kubernetes/resources
wget https://dl.k8s.io/v1.18.3/kubernetes-node-linux-amd64.tar.gz
wget https://github.com/etcd-io/etcd/releases/download/v3.4.9/etcd-v3.4.9-linux-amd64.tar.gz
wget https://github.com/containernetworking/plugins/releases/download/v0.8.6/cni-plugins-linux-amd64-v0.8.6.tgz
wget https://download.docker.com/linux/static/stable/x86_64/docker-19.03.9.tgz
```

> 有些文件的较大，下载花费时间可能较长。可以提前下载好之后，拷贝到虚拟机。

第一段落**机器准备**愉快结束。

---
> [上篇：了解 Volume](了解%20Volume.md)
>
> [下篇：二进制搭建 K8s - 2 部署 etcd 集群](binary-build-k8s-02-deploy-etcd.md)

---
[« apiserver](apiserver.md)

[» 二进制搭建 K8s - 2 部署 etcd 集群](binary-build-k8s-02-deploy-etcd.md)
