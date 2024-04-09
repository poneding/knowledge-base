[我的知识库](../README.md) / [操作系统](zz_gneratered_mdi.md) / Windows 使用姿势

# Windows 使用姿势

## 0. 激活 windows

以管理员身份运行命令行，输入以下三行命令：

```powershell
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
# 等待弹窗出现，点击确定之后，再继续执行下一行命令

slmgr /skms kms.loli.best
# slmgr /skms kms.03k.org
# 同样需要等待弹窗出现，点击确定之后，再继续执行

slmgr /ato
# 正常情况下应该会出现激活成功的弹窗
```

## 1. Windows Terminal SSH 连接超时自动断开

使用 Windows Terminal SSH 连接 linux 服务器，每过一段时间后，就会自动断开。

**解决方案**：

打开配置文件 `%USERPROFILE%/.ssh/config`，在该配置文件中添加配置行：

```ini
ServerAliveInterval 60
```

## 2. VSCode 搭配 Remote-SSH

配置远程访问文件 `%USERPROFILE%/.ssh/config`：

### 密钥文件进行SSH连接

 ```
 Host aliyun
   HostName 11.11.11.11
   User root
   IdentityFile ~/.ssh/aliyun_key
 ```
 
### 用户密码进行SSH连接

```
Host ubuntu
  HostName 192.168.11.11
  User dp
```

但是如果你不是使用密钥形式配置的话，每次连接时都需要输入密码。

**解决方案**：

```bash
cd ~/.ssh
ssh-keygen -t rsa -C "remote" -f ubuntu
```

将生成 `ubuntu` 和 `ubuntu.pub` 文件，将 `ubuntu.pub` 文件内容**追加**拷贝至远程服务器 `~/.ssh/authorized_keys` 文件即可，如果文件不存在，则创建。

## 3. Powershell 命令

清除历史命令

```powershell
Remove-Item (Get-PSReadlineOption).HistorySavePath
```

## 4. 安装 windows11 虚拟机

安装 windwos 虚拟机跳过网络的方法，按下 Shift+F10 或者是 Fn+Shift+F10 快捷键调出命令提示符窗口，执行命令：

```powershell
oobe\BypassNRO
```

---
[上篇：Ubuntu](ubuntu.md)
