[我的知识库](../README.md) / [Kubernetes](zz_generated_mdi.md) / Velero + Minio 备份与恢复

# Velero + Minio 备份与恢复

## 安装 Minio

```bash
docker run -d --name minio \\
    -p 9000:9000 \\
    -p 9001:9001 \\
    -e MINIO_ROOT_USER=minio \\
    -e MINIO_ROOT_PASSWORD=minio \\
    -v /minio-data:/data \\
    quay.io/minio/minio:latest server /data --console-address ":9001"
```

## 创建 Bucket

![image-20230830182006059](https://fs.poneding.com/images/202308301820108.png)

## 设置 Region

![image-20230830182016337](https://fs.poneding.com/images/202308301820368.png)

点击保存后，会出现一个横幅，点击横幅上的 `Restart` 即可。

## 创建 AccessKey

![image-20230830182026649](https://fs.poneding.com/images/202308301820680.png)

保存 AccessKey 和 SecretKey 到文件 `credentials-velero`：

```ini
[default]
aws_access_key_id = <access_key>
aws_secret_access_key = <secret_key>
```

## 安装 Velero CLI

```bash
# linux
wget <https://github.com/vmware-tanzu/velero/releases/download/v1.11.1/velero-v1.11.1-linux-amd64.tar.gz>
tar -xvf velero-v1.11.1-linux-amd64.tar.gz
mv velero-v1.11.1-linux-amd64/velero /usr/local/bin

# completion bash
source /usr/share/bash-completion/bash_completion
echo 'source <(velero completion bash)' >>~/.bashrc
velero completion bash >/etc/bash_completion.d/velero
echo 'alias v=velero' >>~/.bashrc
echo 'complete -F __start_velero v' >>~/.bashrc

# completion zsh
source <(velero completion zsh)
echo 'alias v=velero' >>~/.zshrc
echo 'complete -F __start_velero v' >>~/.zshrc
```

## 在集群中安装 Velero

```bash
velero install \
 --provider aws \
 --plugins velero/velero-plugin-for-aws:main \
 --use-node-agent=true \
 --use-volume-snapshots=false \
 --bucket <your_minio_bucket> \
 --secret-file ./credentials-velero \
 --backup-location-config \
 region=<your_minio_region>,s3ForcePathStyle="true",s3Url=https://<your_minio_server>:9000
```

> 1、`./credentials-velero` 文件中保存 minio 的 AccessKey 和 SecretKey 内容；
>
> 2、修改 bucket、region、和 minio 的服务地址。

## 备份

```bash
velero backup create mysql-backup --selector app=mysql --default-volumes-to-fs-backup 
```

## 还原

```shell
velero restore create --from-backup mysql-backup
```

---
[« Terraform](terraform.md)

[» 了解 Volume](volume-understood.md)
