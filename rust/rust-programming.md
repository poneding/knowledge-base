[我的知识库](../README.md) / [Rust](zz_generated_mdi.md) / rust-programming.md

Rust 编程

## String 与 &str

String：字符串

&str：字符串切片

```rust
let s: &str = "Hello World!";

let s1 = s.to_string(); 
let s1 = String::from(s);

 let s2 = &s1[..];
let s2 = s1.as_ref();
```

## Panic

设置 `RUST_BACKTRACE=1` 环境变量值，可以追踪到 panic 位置，例如：`RUST_BACKTRACE=1 cargo run`

---
[« Rust 开发环境配置](dev-env-config.md)

[» Rust VSCode 调试](vscode-debugging.md)
