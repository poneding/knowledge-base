[我的知识库](../README.md) / [Git](zz_gneratered_mdi.md) / Git 常用

# Git 常用

本篇主要介绍 Git 的常用命令，包括 Git 的基本配置、创建仓库、添加文件、提交文件、查看状态、查看提交历史、撤销修改、删除文件、分支管理、远程仓库等。

## Git 基本配置

### 配置 SSH 密钥

提交代码到远程仓库时，需要使用 SSH 密钥进行身份验证，因此需要先配置 SSH 密钥。

```bash
# 生成 SSH 密钥
ssh-keygen -t rsa -C poneding@gmail.com
# 查看 SSH 密钥，复制到 GitHub/GitLab 等 SSH Keys 中
cat ~/.ssh/id_rsa.pub
```

添加 .ssh/config 文件，配置 SSH 密钥的别名，方便管理多个 SSH 密钥。

```bash
vim ~/.ssh/config
```

以 GitHub 为例，配置如下：

```text
# GitHub
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/id_rsa
```

### 配置用户名和邮箱

提交代码时，需要配置用户名和邮箱。

```bash
git config --global user.name "poneding"
git config --global user.email poneding@gmail.com

# 只配置当前仓库的用户名和邮箱
git config user.name "poneding"
git config user.email poneding@gmail.com
```

### 配置别名

通过配置别名，可以简化 Git 命令的输入，例如，将 `git status` 简化为 `git st` 获取 Git 仓库的状态。

```bash
git config --global alias.st status
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ck checkout
```

### 配置默认分支

最新版本的 Git 默认分支为 `main`，如果需要修改为 `master`，可以通过如下命令进行修改。

```bash
git config --global init.defaultBranch master
```

### 配置 rabase

当你运行 `git pull` 时，Git 会从远程仓库拉取最新的更改并将它们合并到你的本地分支。如果设置了 `pull.rebase` 为 `true`，Git 会在拉取远程更改后，不使用普通的 merge 操作，而是使用 rebase 将你本地的提交放在远程更改的后面。这样可以有效避免分支合并时产生大量的无用的 merge commit，有助于保持一个更线性、整洁的提交历史。

```bash
git config --global pull.rebase true
```

## Git 仓库

### 初始化仓库

```bash
# 在当前目录创建仓库
git init

# 在指定目录创建仓库
git init mydir
```

### 克隆远程仓库

```bash
# SSH 方式
git clone git@github.com/poneding/archives.git

# HTTPS 方式
git clone https://github.com/kubernetes/kubernetes.git
```

### 提交本地更改到远程仓库

```bash
# 拉取远程仓库的最新更改
git pull

# 添加所有更改到暂存区
git add .

# 提交更改
git commit -m "this commit"

# 推送到远程仓库
git push

# 首次推送到远程仓库
git push -u origin master
```

### 添加远程仓库

```bash
# 查看远程仓库
git remote -v 

# 添加远程仓库
git remote add origin git@github.com/poneding/archives.git

# 修改远程仓库地址
git remote set-url origin git@github.com/poneding/archives-new.git

# 删除远程仓库
git remote rm origin
```

## 暂存更改

### 添加文件

```bash
# 将更改添加到暂存区
git stash

# 查看暂存区的更改
git stash list

# 取出暂存区的更改
git stash pop
```

## 撤销更改

### 还未 git add

这里其实涉及到了两种更改：

- 文件新增：使用 `git clean -f` 撤销更改
- 文件修改/删除：使用 `git restore .`（新版，推荐）或 `git checkout .`（旧版） 撤销更改

```bash
git clean -f && git restore .
```

### 已经 git add，还未 git commit

```bash
git reset HEAD .

# 撤销单个文件
git reset HEAD README.md
```

### 已经 git commit

```bash
# 获取最近一次提交的 commit_id
git log

# 撤销最近一次提交
git reset [commit_id]
```

## Git 分支

### 查看分支

```bash
# 查看本地分支
git branch

# 查看远程分支
git branch -r

# 查看所有分支
git branch -a
```

### 创建分支

```bash
# 创建新分支
git branch dev

# 创建并切换到新分支
git checkout -b dev

# 创建孤立分支，新分支没有任何提交历史，但会保留之前分支的所有文件
git checkout --orphan dev
```

### 同步远程分支

远程分支分两种：

1. 本地远程分支，可以通过 `git branch -r` 查看到；
2. 远程仓库分支，可能是其他人创建的，可以通过 `git fetch` 同步到本地远程分支。

```bash
# 远程仓库有了新的分支，将远程分支同步到本地
git fetch

# 将远程分支同步到本地
git checkout -b dev origin/dev
```

### 合并分支

```bash
# 将当前分支 dev 的更改合并到 master 分支
git checkout master
git merge dev
git push
```

### 删除分支

```bash
# 删除本地分支
git branch -d dev

# 删除远程分支
git push origin -d dev
```

场景：远程仓库已经删除了分支，本地仓库还存在该分支，需要删除本地分支。

```bash
# 1. 查看远程分支和本地分支的对应关系:
git remote show origin

# 2. 删除远程已经删除过的分支:
git remote prune origin
```

## Git 标签

### 查看标签

```bash
git tag
```

### 创建标签

```bash
# 创建标签（轻量标签，只是某个提交的引用）
git tag v1.0.0

# 创建标签（附注标签）
git tag -a v1.0.0 -m "release v1.0.0"

# 推送标签到远程仓库
git push origin v1.0.0
```

### 删除标签

```bash
# 删除本地标签
git tag -d v1.0.0

# 删除远程标签
git push origin :refs/tags/v1.0.0

# 本地批量删除标签
git tag | xargs git tag -d

# 本地删除 v1.1.0 开头的标签
git tag | grep "v1.1.0.\d$" | xargs git tag -d

# 批量删除远程标签
git show-ref --tag | awk '/(.*)(\s+)(.*)$/ {print ":" $2}' | xargs git push origin
```

## 删除远程仓库提交历史

```bash
rm -rf .git
git init
git add .
git commit -m "first commit"
git remote add origin git@github.com/poneding/archives.git
# 强制推送到远程仓库，覆盖远程仓库的提交历史
git push -u --force origin master
```

## 排错

### Q1：证书颁发者未被识别

问题描述：Peer’s Certificate issuer is not recognized.

解决方法：

```bash
# 仓库级别，在仓库目录下执行
git config http."sslVerify" false

# 全局级别
git config --global http."sslVerify" false
```

---
[下篇：使用 git-secret 保护仓库敏感数据](git-secret.md)
