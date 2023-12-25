[我的知识库](../README.md) / [操作系统](zz_gneratered_mdi.md) / Ubuntu

# Ubuntu

## 终端默认使用英文

```bash
LANG=en_US.UTF-8
LANGUAGE=en_US:en
LC_ALL=en_US.UTF-8
```

## 下载 arm64 桌面镜像

```bash
https://cdimage.ubuntu.com/jammy/daily-live/current/jammy-desktop-arm64.iso
```

## 关闭防火墙

```bash
sudo ufw disable
sudo ufw status
```

## 修改时区

```bash
sudo cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
sudo timedatectl set-timezone Asia/Shanghai
date

# 同步时间
sudo apt install ntpdate -y
sudo ntpdate cn.pool.ntp.org
```

## 解决英文系统下中文显示问题

修改字体优先级

```bash
sudo vim /etc/fonts/conf.avail/64-language-selector-prefer.conf
```

将 `JP` 和 `KR` 所在行往下调整即可，调整成如下所示：

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
        <alias>
                <family>sans-serif</family>
                <prefer>
                        <family>Noto Sans CJK SC</family>
                        <family>Noto Sans CJK TC</family>
                        <family>Noto Sans CJK HK</family>
                        <family>Noto Sans CJK JP</family>
                        <family>Noto Sans CJK KR</family>
                        <family>Lohit Devanagari</family>
                </prefer>
        </alias>
        <alias>
                <family>serif</family>
                <prefer>
                        <family>Noto Serif CJK SC</family>
                        <family>Noto Serif CJK TC</family>
                        <family>Noto Serif CJK JP</family>
                        <family>Noto Serif CJK KR</family>
                        <family>Lohit Devanagari</family>
                </prefer>
        </alias>
        <alias>
                <family>monospace</family>
                <prefer>
                        <family>Noto Sans Mono CJK SC</family>
                        <family>Noto Sans Mono CJK TC</family>
                        <family>Noto Sans Mono CJK HK</family>
                        <family>Noto Sans Mono CJK JP</family>
                        <family>Noto Sans Mono CJK KR</family>
                </prefer>
        </alias>
</fontconfig>
```

## 安装搜狗输入法

参照官方文档：<https://pinyin.sogou.com/linux/help.php>

```bash
# 禁用ctrl+shift+f
vim ~/.config/sogoupinyin/conf/env.ini
# 找到这行ShortCutFanJian=1，改为ShortCutFanJian=0
vim ~/.config/fcitx/conf/fcitx-chttrans.config
# 找到 #Hotkey=CTRL_SHIFT_F，取消注释，并改为 #Hotkey=CTRL_SHIFT_]
# 保存之后，重新登录即可
```

## 修复 No Wi-Fi Adapter Found 问题

```bash
rfkill unblock all
sudo /etc/init.d/networking restart
sudo rm /etc/udev/rules.d/70-persistent-net.rules
sudo reboot
```

## M720 鼠标优联连接

下载 Solaar

```bash
sudo apt install solaar
```

下载完成之后，插入 USB 接收器，M720 切换至未被占用的 Channel，并重新启动（Off => On）。

打开 Solaar 应用

```bash
solaar
```

如果没有发现 M720 鼠标，则重启 Ubuntu，重启之后再次打开 Solaar 之后，可以看到列表中出现 Solaar，点击 "Pair the device" 即可。

---
[上篇：openssl](openssl.md)

[下篇：Windows使用姿势](windows.md)
