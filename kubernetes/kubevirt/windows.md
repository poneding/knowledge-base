[我的知识库](../../README.md) / [Kubernetes](../zz_generated_mdi.md) / [KubeVirt](zz_generated_mdi.md) / Kubevirt 安装 windows-server-2022

# Kubevirt 安装 windows-server-2022

1. 下载 iso 镜像文件：

	下载地址：<https://www.microsoft.com/evalcenter/download-windows-server-2022>
	
2. 上传到 PVC
```bash
virtctl image-upload pvc windows-server-2022-iso --image-path Files/windows-server-2022.iso --size 10G --uploadproxy-url https://10.43.32.223 --insecure --wait-secs 240
```

`--uploadproxy-url` 中 IP 地址为可以访问的 `cdi-uploadproxy service` 地址（前提时命令运行环境可以访问到该 service），通过以下命令可以获取：

```bash
kubectl get svc -n cdi -l cdi.kubevirt.io=cdi-uploadproxy
```

3. 准备 windows-server-2022-vm.yaml 文件：

```

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: windows-10-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 40G
  storageClassName: longhorn
  volumeMode: Filesystem
---
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: windows-10
spec:
  running: true
  template:
    metadata:
      labels:
        kubevirt.io/domain: windows-10
    spec:
      domain:
        cpu:
          cores: 4
        devices:
          networkInterfaceMultiqueue: true #开启网卡多队列模式
          blockMultiQueue: true #开启磁盘多队列模式
          disks:
          - cdrom: 
              bus: sata
            name: virtiocontainerdisk
          - cdrom: 
              bus: sata
            name: cdromiso
            bootOrder: 1
          - disk:
              bus: virtio
            name: harddrive
            bootOrder: 2
          interfaces:
          - masquerade: {}
            model: virtio
            name: default
        resources:
          requests:
            memory: 8G
      networks:
      - name: default
        pod: {}
      volumes:
      - name: cdromiso
        persistentVolumeClaim:
          claimName: windows-10-iso
      - name: harddrive
        persistentVolumeClaim:
          claimName: windows-10-data
      - containerDisk:
          image: kubevirt/virtio-container-disk
        name: virtiocontainerdisk
```

创建虚拟机：

```bash
kubectl apply -f windows-server-2022-vm.yaml
```

---
[« 制作虚拟机容器镜像](make-virtual-machine-container-image.md)
