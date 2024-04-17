[我的知识库](../README.md) / [Go](zz_generated_mdi.md) / Golang 列表转树

# Golang 列表转树

## 场景介绍

从数据库获取到了菜单列表数据，这些菜单数据通过字段 ParentID 表示父子层级关系，现在需要将菜单列表数据转成树状的实例对象。

数据库取出的初始数据：

```go
raw := []Menu{
	{Name: "一级菜单 1", ID: 1, PID: 0},
	{Name: "一级菜单 2", ID: 2, PID: 0},
	{Name: "一级菜单 3", ID: 3, PID: 0},
	{Name: "二级菜单 1-1", ID: 11, PID: 1},
	{Name: "二级菜单 1-2", ID: 12, PID: 1},
	{Name: "二级菜单 1-3", ID: 13, PID: 1},
	{Name: "二级菜单 2-1", ID: 21, PID: 2},
	{Name: "二级菜单 2-2", ID: 22, PID: 2},
	{Name: "二级菜单 2-3", ID: 23, PID: 2},
}
```

需要得到的目标数据：

```json
{
    "name":"根菜单",
    "id":0,
    "pid":0,
    "SubMenus":[
        {
            "name":"一级菜单 1",
            "id":1,
            "pid":0,
            "SubMenus":[
                {
                    "name":"二级菜单 1-1",
                    "id":11,
                    "pid":1
                },
                {
                    "name":"二级菜单 1-2",
                    "id":12,
                    "pid":1
                },
                {
                    "name":"二级菜单 1-3",
                    "id":13,
                    "pid":1
                }
            ]
        },
        {
            "name":"一级菜单 2",
            "id":2,
            "pid":0,
            "SubMenus":[
                {
                    "name":"二级菜单 2-1",
                    "id":21,
                    "pid":2
                },
                {
                    "name":"二级菜单 2-2",
                    "id":22,
                    "pid":2
                },
                {
                    "name":"二级菜单 2-3",
                    "id":23,
                    "pid":2
                }
            ]
        },
        {
            "name":"一级菜单 3",
            "id":3,
            "pid":0
        }
    ]
}
```

## 代码实现

```go
package main

import (
	"encoding/json"
	"fmt"
)

func main() {
	// 数据库里存储的菜单
	rawMenus := []Menu{
		{Name: "一级菜单 1", ID: 1, PID: 0},
		{Name: "一级菜单 2", ID: 2, PID: 0},
		{Name: "一级菜单 3", ID: 3, PID: 0},
		{Name: "二级菜单 1-1", ID: 11, PID: 1},
		{Name: "二级菜单 1-2", ID: 12, PID: 1},
		{Name: "二级菜单 1-3", ID: 13, PID: 1},
		{Name: "二级菜单 2-1", ID: 21, PID: 2},
		{Name: "二级菜单 2-2", ID: 22, PID: 2},
		{Name: "二级菜单 2-3", ID: 23, PID: 2},
	}
	menu := &Menu{
		Name: "根菜单",
		PID:  0,
	}

	for _, rm := range rawMenus {
		menu.setSubMenus(rm)
	}

	// 打印结果
	b, _ := json.Marshal(menu)
	fmt.Println(string(b))
}

type Menu struct {
	Name     string `json:"name"`
	ID       int    `json:"id"`
	PID      int    `json:"pid"`
	SubMenus []Menu `json:",omitempty"`
}

func (m *Menu) setSubMenus(menu Menu) bool {
	if menu.PID == m.ID {
		m.SubMenus = append(m.SubMenus, menu)
		return true
	}
	for i := range m.SubMenus {
		if m.SubMenus[i].setSubMenus(menu) {
			return true
		}
	}
	return false
}
```

## 注意事项

Golang for 遍历使用 `for _, item := range slice` 时，`item` 是一份遍历元素的复制，而使用 `for i := range slice` 时，`slice[i]` 则是遍历元素本身，使用时需要注意切片扩容带来的地址变化问题。

---
[« go:linkname 指令](go-linkname.md)

[» Golang 实现双向认证](go-mtls.md)
