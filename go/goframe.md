[我的知识库](../README.md) / [Go](zz_generated_mdi.md) / GoFrame

# GoFrame

## 安装 goframe

适用于 MacOS 和 Linux

```bash
wget -O gf "https://github.com/gogf/gf/releases/latest/download/gf_$(go env GOOS)_$(go env GOARCH)" && chmod +x gf && ./gf install -y && rm ./gf
```

`gf` 命令行工具与 `git fetch` 命令冲突：

```bash
vim ~/.zshrc

alias gf=gf

GLOBALIAS_FILTER_VALUES=(gf)
```


---
[« Golang](go.md)

[» gopkg-errors.md](gopkg-errors.md)
