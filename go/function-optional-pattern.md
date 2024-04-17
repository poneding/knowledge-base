[我的知识库](../README.md) / [Go](zz_generated_mdi.md) / Golang 函数可选参数模式

# Golang 函数可选参数模式

## 函数可选参数模式

```go
type Server struct {
    Addr    string
    Timeout time.Duration
}

type Option func(*Server)

func newServer(addr string, options ...Option) (*Server, error) {
    s := &Server{
        Addr: addr,
    }
    for _, opt := range options {
        opt(s)
    }
    // ...
    return s, nil
}

func WithTimeout(timeout time.Duration) Option {
    return func(s *Server) {
        s.Timeout = timeout
    }
}
```

## 通用函数可选参数模式

```go
type BasicService struct {
    redisClient string
}

type ServiceOption func(*BasicService)

func WithRedisClient(redisClient string) ServiceOption {
    return func(s *BasicService) {
        s.redisClient = redisClient
    }
}

type UserService struct {
    *BasicService
}

type OrderService struct {
    *BasicService
}

func newUserService(opts ...ServiceOption) *UserService {
    us := &UserService{BasicService: new(BasicService)}
    for _, opt := range opts {
        opt(us.BasicService)
    }
    return us
}

func newOrderService(opts ...ServiceOption) *OrderService {
    os := &OrderService{BasicService: new(BasicService)}
    for _, opt := range opts {
        opt(os.BasicService)
    }
    return os
}

func TestNewService(t *testing.T) {
    us := newUserService(WithRedisClient("redis"))
    t.Log(us.redisClient)

    os := newOrderService(WithRedisClient("redis"))
    t.Log(os.redisClient)
}
```

![202312210911571.png](https://images.poneding.com/2023/12/202312210911571.png)

---
[« Untitled.md](Untitled.md)

[» Golang 密钥对、数字签名和证书管理](go-cert-management.md)
