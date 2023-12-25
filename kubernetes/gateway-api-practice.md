[我的知识库](../README.md) / [Kubernetes](zz_gneratered_mdi.md) / Gateway API 实践

# Gateway API 实践

Gateway API 还在积极开发中，目前已经发布了 v1.0.0 版本。可以通过 [gateway-api 文档](https://gateway-api.sigs.k8s.io/) 获取最新进展。

## Gateway API 概述

Gateway API 是一个 Kubernetes 的扩展 API，它定义了一套 API 来管理网关、路由、TLS 等资源对象，可以用来替代传统的 Ingress。

和 Ingress 一样，Gateway API 也是一个抽象层，它定义了一套 API 接口，这些接口由社区中的不同厂商来实现，比如 `nginx`、`envoy`、`traefik` 等。

## API 清单

- [GatewayClass](https://gateway-api.sigs.k8s.io/api-types/gatewayclass/)
- [Gateway](https://gateway-api.sigs.k8s.io/api-types/gateway/)
- [HTTPRoute](https://gateway-api.sigs.k8s.io/api-types/httproute/)
- [GRPCRoute](https://gateway-api.sigs.k8s.io/api-types/grpcroute/)
- [BackendTLSPolicy](https://gateway-api.sigs.k8s.io/api-types/backendtlspolicy/)
- [ReferenceGrant](https://gateway-api.sigs.k8s.io/api-types/referencegrant/)

![202311161115426.png](https://images.poneding.com/2023/11/202311161115426.png)

## 安装 Gateway API

```bash
# 安装最新版 gateway-api CRDs
export LATEST=$(curl -s https://api.github.com/repos/kubernetes-sigs/gateway-api/releases/latest | jq -r .tag_name)
kubectl apply -f https://github.com/nginxinc/nginx-gateway-fabric/releases/download/$LATEST/crds.yaml
```

## 安装 Gateway Controller

`gateway-api` 只是定义了一套 API，需要 `gateway-controller` 来实现这些 API。目前已经有许多厂商实现了 `gateway-controller`，比如 `nginx`、`envoy`、`traefik` 等。

下面介绍如何安装 [`nginx-gateway-fabric`](https://github.com/nginxinc/nginx-gateway-fabric)：

```bash
# 安装最新版 gateway-controller
export LATEST=$(curl -s https://api.github.com/repos/nginxinc/nginx-gateway-fabric/releases/latest | jq -r .tag_name)
kubectl apply -f https://github.com/nginxinc/nginx-gateway-fabric/releases/download/$LATEST/nginx-gateway.yaml
```

配置 nginx-gateway 使用主机网络：

```bash
kubectl patch deployment nginx-gateway -n nginx-gateway --type='json' -p='[{"op": "add", "path": "/spec/template/spec/hostNetwork", "value": true}]'
```

> 注意：配置使用主机网络之后，宿主机的 80 端口将被占用，因此一个节点只允许调度一个 nginx-gateway Pod，当更新 nginx-gateway 时，您可能需要先停止旧的 Pod，再启动新的 Pod。

在使用过程中，发现有可能由于宿主机的差异导致 `nginx-gateway` 健康检查无法通过，Pod 不能正常启动。可以通过修改配置 `allowPrivilegeEscalation` 字段来解决：

```bash
# 使用主机网络，端口被占用，需要先停止 nginx-gateway
kubectl scale deployment nginx-gateway -n nginx-gateway --replicas=0
kubectl patch deployment nginx-gateway -n nginx-gateway --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/securityContext/allowPrivilegeEscalation", "value": true}]'
kubectl scale deployment nginx-gateway -n nginx-gateway --replicas=1
```

## 实践

### 简单网关路由

部署 nginx deployment，并且暴露服务：

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --name=nginx --port=80 --target-port=80
```

部署 nginx gateway & httpRoute：

```bash

```bash
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    hostname: "*.mydomain.com"
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: nginx
spec:
  parentRefs:
  - name: gateway
    sectionName: http
  hostnames:
  - "nginx.mydomain.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: nginx
      port: 80
```

### TLS 网关路由：CertManager + Let's Encrypt

特定域名网关：

```bash
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: mydomain-cert-issuer
spec:
  acme:
    email: poneding@gmail.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: mydomain-cert-issuer-account-key
    solvers:
    - http01:
        gatewayHTTPRoute:
          parentRefs: 
          - name: nginx-gateway
            namespace: nginx-gateway
            kind: Gateway
      selector:
        dnsNames:
        - "nginx.mydomain.com"
---
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: nginx-gateway
  namespace: nginx-gateway
  annotations:
    cert-manager.io/cluster-issuer: mydomain-cert-issuer
spec:
  gatewayClassName: nginx
  listeners:
  - name: nginx-mydomain-https
    hostname: 'nginx.mydomain.com'
    protocol: HTTPS
    port: 443
    allowedRoutes:
      namespaces:
        from: All
    tls:
      certificateRefs:
      - group: ""
        kind: Secret
        name: nginx-mydomain-https-cert
      mode: Terminate
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: nginx
spec:
  parentRefs:
  - name: nginx-gateway
    namespace: nginx-gateway
    sectionName: nginx-mydomain-https
  hostnames:
  - "nginx.mydomain.com"
  rules:
  - matches:
    backendRefs:
    - name: nginx
      port: 80
```

通配符域名（泛域名）网关：

```bash
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token
  namespace: cert-manager
type: Opaque
stringData:
  api-token: [your_cloudflare_api_token]
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: mydomain-cert-issuer
spec:
  acme:
    email: poneding@gmail.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: mydomain-cert-issuer-account-key
    solvers:
    - dns01:
        cloudflare:
          apiTokenSecretRef:
            name: cloudflare-api-token
            key: api-token
      selector:
        dnsNames:
        - "*.gateway.mydomain.com"
---
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: nginx-gateway
  namespace: nginx-gateway
  annotations:
    cert-manager.io/cluster-issuer: mydomain-cert-issuer
spec:
  gatewayClassName: nginx
  listeners:
  # encrypted by cloudflare
  - name: wildcard-mydomain-http
    hostname: '*.mydomain.com'
    protocol: HTTP
    port: 80
    allowedRoutes:
      namespaces:
        from: All
  - name: wildcard-gateway-mydomain-http
    hostname: '*.gateway.mydomain.com'
    protocol: HTTP
    port: 80
    allowedRoutes:
      namespaces:
        from: All
  - name: wildcard-gateway-mydomain-https
    hostname: '*.gateway.mydomain.com'
    protocol: HTTPS
    port: 443
    allowedRoutes:
      namespaces:
        from: All
    tls:
      certificateRefs:
      - group: ""
        kind: Secret
        name: wildcard-gateway-mydomain-cert
      mode: Terminate
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: nginx
spec:
  parentRefs:
  - name: nginx-gateway
    namespace: nginx-gateway
    sectionName: wildcard-gateway-mydomain-https
  hostnames:
  - "nginx.gateway.mydomain.com"
  rules:
  - matches:
    backendRefs:
    - name: nginx
      port: 80
```

---
[上篇：强制删除 K8s 资源](delete-k8s-resource-force.md)

[下篇：Kubernetes 0-1 Helm Kubernetes 的包管理工具](helm-k8s-package-management-tool.md)
