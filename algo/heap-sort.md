[我的知识库](../README.md) / [算法与数据结构](zz_generated_mdi.md) / 堆排序

# 堆排序

堆排序是利用**堆**这种数据结构而设计的一种排序算法，堆排序是一种**选择排序，**它的最坏，最好，平均时间复杂度均为 `O(nlogn)`，它也是不稳定排序。首先简单了解下堆结构。

## 堆

**堆是具有以下性质的完全二叉树：每个结点的值都大于或等于其左右孩子结点的值，称为大顶堆；或者每个结点的值都小于或等于其左右孩子结点的值，称为小顶堆。**：

![img](https://fs.poneding.com/images/1024555-20161217182750011-675658660.png)

## 算法实现（golang）

```golang
package main

import "fmt"

type BinaryTreeNode struct {
 Value       int
 Left, Right *BinaryTreeNode
}

func main() {
 tree := &BinaryTreeNode{
  Left: &BinaryTreeNode{
   Left: &BinaryTreeNode{
    Value: 1,
   },
   Right: &BinaryTreeNode{
    Value: 2,
   },
   Value: 3,
  },
  Right: &BinaryTreeNode{
   Value: 4,
  },
  Value: 5,
 }

 res := HeapSort(tree)
 fmt.Println(res)
}

func HeapSort(tree *BinaryTreeNode) []int {
 var res []int
 if tree == nil {
  return []int{}
 }
 res = heapSortHelper(tree, res)
 return res
}

func heapSortHelper(tree *BinaryTreeNode, res []int) []int {
 if tree.Left == nil {
  res = append(res, tree.Value)
 } else {
  res = heapSortHelper(tree.Left, res)
  res = heapSortHelper(tree.Right, res)
  res = append(res, tree.Value)
 }
 return res
}
```

---
[» 快速排序](quick-sort.md)
