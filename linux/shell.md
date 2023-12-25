[我的知识库](../README.md) / [Linux](zz_gneratered_mdi.md) / shell 基础

# shell 基础

## shell 注释

单行注释：

```shell
# 注释内容
```

多行注释：

```shell
:<<EOF
注释内容
注释内容
注释内容
EOF
```

或

```shell
:<<!
注释内容
注释内容
注释内容
!
```

或

```shell
:<<'
注释内容
注释内容
注释内容
'
```

## shell 变量

定义变量：

```shell
my_name="Ding Peng"
```

使用变量：

```shell
$my_name
${my_name}
```

只读变量：

```shell
my_name="Ding Peng"
readonly my_name 
```

删除变量：

```shell
unset my_name
```

变量类型：

> 1. 局部变量：在脚本或命令中定义，仅在当前shell实例有效
> 2. 环境变量：所有shell实例有效
> 3. shell变量：shell程序设置的特殊变量

## shell 字符串

> 单引号与双引号的区别：
>
> 1. 单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的；
> 2. 单引号字串中不能出现单独一个的单引号（对单引号使用转义符后也不行），但可成对出现，作为字符串拼接使用；
> 3. 双引号里可以有变量；
> 4. 双引号里可以出现转义字符

```shell
my_name="Ding Peng"
hello_string="Hllo,\"$my_name\"!"
echo $hello_string
```

获取字符串长度：

```shell
my_name="dp"
echo ${#my_name} # 输出5
```

截取字符串：

```shell
hello_world="Hello World!"

# 从index 1截取4个字符
echo ${hello_world:1:4}  # 输出ello
```

## shell 数组

> 只有以为数组，没有多维数组

```shell
# 定义数组，空格隔开
names=('Ding Peng' 'Jay Chou' "Lebron James")

# 获取数组元素，根据index获取
echo ${names[1]}

# 获取数组长度
echo ${#names[@]}
echo ${#names[*]}
```

## shell 传参

执行shell脚本文件时，传递参数

假如有一个test.sh文件内容如下：

```shell
#!/bin/bash

echo "Shell 传递参数实例！";

# 使用$n接收参数
echo "执行的文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
```

```shell
chmod +x test.sh
./test.sh 1 2 
```

> 第一行命令给test.sh添加可执行权限
>
> 第二行命令执行test.sh文件
>
> 以上命令将输出：
>
> ```shell
> Shell 传递参数实例！
> 执行的文件名：./test.sh
> 第一个参数为：1
> 第二个参数为：2
> ```

其他参数处理：

| 参数 | 说明                                                 |
| ---- | ---------------------------------------------------- |
| $#   | 传递到脚本的参数个数                                 |
| $*   | 以一个单字符串显示所有向脚本传递的参数               |
| $$   | 脚本运行的当前进程ID号                               |
| $@   | 与$*相同，但是使用时加引号，并在引号中返回每个参数。 |

## shell if 控制语句

`if`  后面需要接者 `then`：

```shell
if [ condition-for-test ]
then
  command
  ...
fi
```

或者，

```shell
if [ condition-for-test ]; then
  command
  ...
fi
```

如：

```shell
#!/bin/bash
 
VAR=myvar
if [ $VAR = myvar ]; then
    echo "1: \$VAR is $VAR"   # 1: $VAR is myvar
fi
if [ "$VAR" = myvar ]; then
    echo "2: \$VAR is $VAR"   # 2: $VAR is myvar
fi
if [ $VAR = "myvar" ]; then
    echo "3: \$VAR is $VAR"   # 3: $VAR is myvar
fi
if [ "$VAR" = "myvar" ]; then
    echo "4: \$VAR is $VAR"   # 4: $VAR is myvar
fi
```

上面，我们在比较时，可以用双引号把变量引用起来。

但要注意单引号的使用。

```shell
#!/bin/bash
VAR=myvar
if [ '$VAR' = 'myvar' ]; then
    echo '5a: $VAR is $VAR'
else
    echo "5b: Not equal."
fibas
# Output:
# 5b: Not equal.
```

上面这个就把  `'$VAR'`  当一个字符串了。

但如果变量是多个单词，我们就必须用到双引号了，如

```shell
#!/bin/bash

# 这样写就有问题
VAR1="my var"
if [ $VAR1 = "my var" ]; then
    echo "\$VAR1 is $VAR1"
fi
# Output
# error [: too many arguments

# 用双引号
if [ "$VAR1" = "my var" ]; then
    echo "\$VAR1 is $VAR1"
fi
```

总的来说，双引号可以一直加上。

### 空格问题

比较表达式中，如果 `=` 前后没有空格，那么整个表法式会被认为是一个单词，其判断结果为 `True`.

```shell
#!/bin/bash
 
VAR2=2
#  由于被识别成一个单词， [] 里面为 true
if [ "$VAR2"=1 ]; then
    echo "$VAR2 is 1."
else
    echo "$VAR2 is not 1."
fi
# Output
# 2 is 1.

# 前后加上空格就好了
if [ "$VAR2" = 1 ]; then
    echo "$VAR2 is 1."
else
    echo "$VAR2 is not 1."
fi
# Output
# 2 is not 1.
```

另外需要注意的是， 在判断中，中括号 `[`  和变量之间一定要有一个空格，`=` 或者 `==`。 如果缺少了空格，你可能会到这类似这样的错误：`unary operator expected’ or missing`]` 。

```shell
# 正确， 符号前后有空格
if [ $VAR2 = 1 ]; then
    echo "\$VAR2 is 1."
else
    echo "It's not 1."
fi
# Output
# 2 is 1.

# 错误， 符号前后无空格
if [$VAR2=1]; then
    echo "$VAR2 is 1."
else
    echo "It's not 1."
fi
# Output
# line 3: =1: command not found
# line 5: [=1]: command not found
# It's not 1.
```

### 文件测试表达式

对文件进行相关测试，判断的表达式如下：

| 表达式              | True                                     |
| :------------------ | :--------------------------------------- |
| *file1* -nt *file2* | *file1* 比 *file2* 新。                  |
| *file1* -ot *file2* | *file1* 比 *file2* 老。                  |
| -d *file*           | 文件*file*存在，且是一个文件夹。         |
| -e *file*           | 文件 *file* 存在。                       |
| -f *file*           | 文件*file*存在，且为普通文件。           |
| -L *file*           | 文件*file*存在，且为符号连接。           |
| -O *file*           | 文件 *flle* 存在, 且由有效用户 ID 拥有。 |
| -r *file*           | 文件 *flle* 存在, 且是一个可读文件。     |
| -s *file*           | 文件 *flle* 存在, 且文件大小大于 0。     |
| -w file             | 文件 *flle* 可写入。                     |
| -x file             | 文件 *flle* 可写执行。                   |

可以使用 `man test` 查看详细的说明。

当表达式为 `True` 时，测试命令返回退出状态 0，而表达式为 `False` 时返回退出状态1。

```shell
#!/bin/bash
FILE="/etc/resolv.conf"
if [ -e "$FILE" ]; then
  if [ -f "$FILE" ]; then
      echo "$FILE is a file."
  fi
  if [ -d "$FILE" ]; then
      echo "$FILE is a directory."
  fi
  if [ -r "$FILE" ]; then
      echo "$FILE is readable."
  fi
fi
```

### 字符串比较表达式

| 表达式                                      | True                      |
| :------------------------------------------ | :------------------------ |
| *string1 = string2* 或 *string1 == string2* | 两字符相等                |
| *string1* != *string2*                      | 两个字符串不相等          |
| *string1* > *string2*                       | *string1* 大于 *string2*. |
| *string1* < *string2*                       | *string1* 小于*string2*.  |
| -n *string*                                 | 字符串长度大于0           |
| -z *string*                                 | 字符串长度等于0           |

```shell
#!/bin/bash
STRING=""
if [ -z "$STRING" ]; then
  echo "There is no string." >&2 
  exit 1
fi

# Output
# There is no string.
```

其中 `>&2` 将错误信息定位到标准错误输出。

### 数字比较表达式

下面这些是用来比较数字的一些表达式。

| […]                   | ((…))                  | True                |
| :-------------------- | :--------------------- | :------------------ |
| [ “int1” -eq “int2” ] | (( “int1” == “int2” )) | 相等.               |
| [ “int1” -nq “int2” ] | (( “int1” != “int2” )) | 不等.               |
| [ “int1” -lt “int2” ] | (( “int1” < “int2” ))  | int2 大于 int1.     |
| [ “int1” -le “int2” ] | (( “int1” <= “int2” )) | int2 大于等于 int1. |
| [ “int1” -gt “int2” ] | (( “int1 > “int2” ))   | int1 大于 int2      |
| [ “int1” -ge “int2” ] | (( “int1 >= “int2” ))  | int1 大于等于 int2  |

## shell 运算符

### 算数运算符

```shell
val1=`expr 2 + 2`
val2=`expr 2 - 2`
val3=`expr 2 \* 2` # *前面必须加\
val4=`expr 2 / 2`
val5=`expr 2 % 2`

echo "2 + 2: $val1"
echo "2 - 2: $val2"
echo "2 * 2: $val3"
echo "2 / 2: $val4"
echo "2 % 2: $val5"
```

> 注意：
>
> - 使用反引号而不是单引号；
> - 关键字expr；
> - 运算符如：+-*/% 字符前后都需要空格，否则被认为是字符串

其他算数运算符：

| 运算符 | 说明 | 示例                 |
| ------ | ---- | -------------------- |
| =      | 赋值 | a=$b                 |
| ==     | 判等 | `[ $a == $b ] 返回0` |
| !=     | 不等 | `[ $a != $b ] 返回1` |

### 关系运算符

| 运算符 | 说明     | 示例            |
| ------ | -------- | --------------- |
| -eq    | 等于     | `[ $a -eq $b ]` |
| -ne    | 不等于   |                 |
| -gt    | 大于     |                 |
| -lt    | 小于     |                 |
| -ge    | 大于等于 |                 |
| -le    | 小于等于 |                 |

> 注意：
>
> - 关系运算符只适用于数字，不支持字符串，除非字符串的值是数字

### 布尔运算符

| 运算符 | 说明   | 示例                         |
| ------ | ------ | ---------------------------- |
| !      | 非运算 | `[ $a != $b ]`               |
| -o     | 或运算 | `[ $a -eq $b -o $c -eq $d ]` |
| -a     | 与运算 | `[ $a -eq $b -a $c -eq $d ]` |

### 逻辑运算符

| 运算符 | 说明   | 示例                           |
| ------ | ------ | ------------------------------ |
| &&     | 与运算 | `[[ $a -eq $b && $c -eq $d ]]` |
| \|\|   | 或运算 | `[[ $a -eq $b || $c -eq $d ]]` |

> 说明：
>
> - 需要两层[]

### 字符串运算符

| 运算符 | 说明                            | 示例           |
| ------ | ------------------------------- | -------------- |
| =      | 判等                            | `[ $a = $b ]`  |
| !=     | 不等                            | `[ $a != $b ]` |
| -z     | 字符长度是否为0                 | `[ -z $a ]`    |
| -n     | 字符串长度不为0                 | `[ -n $b ]`    |
| $      | 字符串不为空，empty或whitespace | `[ $a ]`       |

### 文件测试运算符

| 运算符  | 说明                           | 示例               |
| ------- | ------------------------------ | ------------------ |
| -b file | 是否为块设备文件               | `[ -b $filepath ]` |
| -c file | 是否为字符设备文件             |                    |
| -d file | 是否为目录                     |                    |
| -f file | 是否为普通文件（非设备文件）   |                    |
| -g file | 是否设置SGID位                 |                    |
| -k file | 是否设置了粘着位（sticky bit） |                    |
| -p file | 是否有名管道                   |                    |
| -u file | 是否设置SUID位                 |                    |
| -r file | 是否可读                       |                    |
| -w file | 是否可写                       |                    |
| -x file | 是否可执行                     |                    |
| -s file | 是否不为空文件（文件大小为0）  |                    |
| -e file | 文件（目录）是否存在           |                    |
| -S file | 文件是否socket                 |                    |
| -L file | 文件是否存在并且是一个符号链接 |                    |

## shell 命令

### echo

打印字符串：

> - 可以是带双引号，单引号，不带引号
> - 可以转义
> - 可以用参数

```shell
echo "Hello World"
echo 'Hello World'
echo Hello World

name="Ding Peng"
echo "Hello, $name!"

# -e 开启转义
echo -e "Hi Ding,\n" # 两行之间空一行
echo "Nice to meet you."

echo -e "Hi Jay,\c"  # 不会换行，都在一行内输出
echo "Nice to meet you." 

echo -e "Hi James,\r" # 会换行，但是没有\r也会默认换行的。
echo -e "Nice to meet you."
```

打印到某文件：

```shell
echo "Hello World" > temp.txt 
```

变量不转义，原样输出：

```shell
echo '$name'
echo '\*'
```

> 说明：
>
> - 需要用单引号

显示命令执行结果：

```shell
echo `date`
```

> 说明：
>
> - 使用反引号，不是单引号

### read

> 交互，获取控制台输入并赋值给某变量

```shell
read name
echo $name
```

### printf

> 输出命令，移植性优于echo。默认不换行，可以在字符串后添加\n

```shell
printf "Hello\n" 
```

通过以下脚本学习printf命令的一些格式化功能

```shell
printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg  
printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234 
printf "%-10s %-8s %-4.2f\n" 杨过 男 48.6543 
printf "%-10s %-8s %-4.2f\n" 郭芙 女 47.9876 
```

> - %s %c %d %f都是格式替代符
> - %-10s 指一个宽度为10个字符（-表示左对齐，没有则表示右对齐），任何字符都会被显示在10个字符宽的字符内，如果不足则自动以空格填充，超过也会将内容全部显示出来。
> - %-4.2f 指格式化为小数，其中.2指保留2位小数。

## shell 变量引用

当你要使用变量的时候，用 `$` 来引用， 如果后面要接一些其他字符，可以用 `{}` 括起来。

```shell
#!/bin/bash
WORLD="world world"
echo "hello $WORLD"  # hello world world
echo "hello ${WORLD}2" # hello world world2
```

在 Bash 中要注意 单引号 `'` ，双引号 `"` ，反引号 ` 的区别。

单引号，双引号都能用来保留引号内的为文字值，其差别在于，双引号在遇到 `$(参数替换)` ，反引号 `(命令替换) 的时候有例外，单引号则剥夺其中所有字符的特殊含义。

而反引号的作用 和 `$()` 是差不多的。 在执行一条命令的时候，会先执行其中的命令，再把结果放到原命令中。

```shell
#!/bin/bash
var="music"
sports='sports'
echo "I like $var"   # I like music
echo "I like ${var}" # I like music
echo I like $var     # I like music
echo 'I like $var'   # I like $var
echo "I like \$var"  # I like $var
echo 'I like \$var'  # I like \$var
echo `bash -version` # GNU bash, version 5.0.17(1)-release (x86_64-pc-linux-gnu)...
echo 'bash -version' # bash -version
```

## shell 经典实例

### 删除确认

```shell
#!/bin/bash
delete_sure
delete_sure(){
  cat << eof
$(echo -e "\033[1;36mNote:\033[0m")
Delete the KubeSphere cluster, including the module kubesphere-system kubesphere-devops-system kubesphere-monitoring-system kubesphere-logging-system openpitrix-system.
eof

read -p "Please reconfirm that you want to delete the KubeSphere cluster.  (yes/no) " ans
while [[ "x"$ans != "xyes" && "x"$ans != "xno" ]]; do
    read -p "Please reconfirm that you want to delete the KubeSphere cluster.  (yes/no) " ans
done

if [[ "x"$ans == "xno" ]]; then
    exit
fi
}
```

---
[上篇：shell 命令间隔符](shell-command-interval-character.md)

[下篇：使用 SSH Tunnel 连接中间件](ssh-tunnel-connect-middleware.md)
