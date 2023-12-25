[我的知识库](../README.md) / [Golang](zz_gneratered_mdi.md) / 使用 Go 生成 OpenSSH 兼容的 RSA 密钥对

# 使用 Go 生成 OpenSSH 兼容的 RSA 密钥对

我们可以使用 ssh-keygen 命令生成一对用于 SSH 访问的私钥和公钥。本文将介绍如何使用 Go 生成一对 OpenSSH 兼容的 RSA 密钥对。

以下代码中 `GenOpenSSHKeyPair` 方法用于生成一对用于 SSH 访问的私钥和公钥。生成的私钥以 PEM 编码，公钥以 OpenSSH authorized_keys 文件中包含的格式进行编码。

```go
package util

import (
    "crypto/rand"
    "crypto/rsa"
    "crypto/x509"
    "encoding/pem"

    "golang.org/x/crypto/ssh"
)

// GenOpenSSHKeyPair make a pair of private and public keys for SSH access.
// Private Key generated is PEM encoded
// Public key is encoded in the format for inclusion in an OpenSSH authorized_keys file.
func GenOpenSSHKeyPair() ([]byte, []byte, error) {
    privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
    if err != nil {
        return nil, nil, err
    }   
    privateKeyPEM := &pem.Block{
        Type:  "RSA PRIVATE KEY",
        Bytes: x509.MarshalPKCS1PrivateKey(privateKey),
    }   
    rsaSSHPriKeyBytes := pem.EncodeToMemory(privateKeyPEM)  
    pub, err := ssh.NewPublicKey(&privateKey.PublicKey)
    if err != nil {
        return nil, nil, err
    }   
    rsaSSHPubKeyBytes := ssh.MarshalAuthorizedKey(pub)  
    return rsaSSHPriKeyBytes, rsaSSHPubKeyBytes, nil
}
```

---
[上篇：pprof](pprof.md)
