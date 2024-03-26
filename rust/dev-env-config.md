[我的知识库](../README.md) / [Rust](zz_gneratered_mdi.md) / Rust 开发环境配置

# Rust 开发环境配置

## 安装

Linux & Mac：

```bash
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
```

一些常用的 Rust 包依赖于 C 代码，因此可能需要额外安装 C 编译器，在 Mac 上通过运行以下命令可以获得 C 编译器：

```bash
xcode-select --install
```

Ubuntu 上通过运行以下命令可以获得 C 编译器：

```bash
sudo apt install build-essential
```

## 更新

```bash
rustup update
```

## 卸载

```bash
rustup self uninstall
```

## 配置命令补全

查看帮助：

```bash
rustup completions --help
```

以 Ubuntu 为例，创建目录：

```bash
mkdir ~/.zfunc
```

在 .zshrc 文件中添加内容：

```bash
fpath+=~/.zfunc
autoload -Uz compinit && compinit
```

生成补全脚本：

```bash
rustup completions zsh > ~/.zfunc/_rustup
rustup completions zsh cargo > ~/.zfunc/_cargo
```

注销重新登录以生效，或者直接运行以下命令：

```bash
exec zsh
```

---
[上篇：Rust cargo 管理工具](cargo-tools.md)

[下篇：Rust VSCode 调试](vscode-debugging.md)
