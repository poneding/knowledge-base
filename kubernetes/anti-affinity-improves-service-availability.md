[我的知识库](../README.md) / [Kubernetes](zz_generated_mdi.md) / 反亲和性提高服务可用性

# 反亲和性提高服务可用性

在 Kubernetes 中部署服务时，我们通常会部署多副本来提高服务的可用性。但是当这些副本集中部署在一个节点，而且很不幸，该节点出现故障，那么服务很容易陷入不可用状态。

下面介绍一种方法，将服务副本分散部署在不同的节点（把鸡蛋放在不同的篮子里），避免单个节点故障导致服务多副本毁坏，提高服务可用性。

## 反亲和

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 5
  template:
    metadata:
      labels:
        app: nginx
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                  - key: app
                    operator: In
                    values:
                      - nginx
              topologyKey: kubernetes.io/hostname
      containers:
        - name: nginx
          image: nginx
          ports:
            - name: tcp
              containerPort: 80
```

> 使用 `kubernetes.io/hostname` 作为拓扑域,查看匹配规则，即同一打有同样标签 `app=nginx` 的 pod 会调度到不同的节点。

podAntiAffinity 使用场景：

- 将一个服务的 Pod 分散在不同的主机或者拓扑域中，提高服务本身的稳定性。
- 给 Pod 对于一个节点的独占访问权限来保证资源隔离，保证不会有其它 Pod 来分享节点资源。
- 把可能会相互影响的服务的 Pod 分散在不同的主机上

对于亲和性和反亲和性，每种都有三种规则可以设置：

- RequiredDuringSchedulingRequiredDuringExecution：在调度期间要求满足亲和性或者反亲和性规则，如果不能满足规则，则 Pod 不能被调度到对应的主机上。在之后的运行过程中，如果因为某些原因（比如修改 label）导致规则不能满足，系统会尝试把 Pod 从主机上删除（现在版本还不支持）。
- RequiredDuringSchedulingIgnoredDuringExecution：在调度期间要求满足亲和性或者反亲和性规则，如果不能满足规则，则 Pod 不能被调度到对应的主机上。在之后的运行过程中，系统不会再检查这些规则是否满足。
- PreferredDuringSchedulingIgnoredDuringExecution：在调度期间尽量满足亲和性或者反亲和性规则，如果不能满足规则，Pod 也有可能被调度到对应的主机上。在之后的运行过程中，系统不会再检查这些规则是否满足。

### 亲和性/反亲和性调度策略比较

| 调度策略        | 匹配标签 |                 操作符                  | 拓扑域支持 |         调度目标         |
| --------------- | -------: | :-------------------------------------: | ---------: | :----------------------: |
| nodeAffinity    |     主机 | In, NotIn, Exists, DoesNotExist, Gt, Lt |         否 |      pod 到指定主机       |
| podAffinity     |      Pod |     In, NotIn, Exists, DoesNotExist     |         是 |  pod 与指定 pod 同一拓扑域  |
| PodAntiAffinity |      Pod |     In, NotIn, Exists, DoesNotExist     |         是 | pod 与指定 pod 非同一拓扑域 |

---
[» apiserver-builder](apiserver-builder.md)
