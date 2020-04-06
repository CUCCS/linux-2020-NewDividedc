# 实验二

## 软件环境

* Ubuntu 18.04 Server 64bit

## 实验要求

* 在asciinema注册一个账号，并在本地安装配置好asciinema

* 确保本地已经完成asciinema auth，并在asciinema成功关联了本地账号和在线账号

* 上传本人亲自动手完成的vimtutor操作全程录像

* 在自己的github仓库上新建markdown格式纯文本文件附上asciinema的分享URL

* 提醒 避免在终端操作录像过程中暴漏密码、个人隐私等任何机密数据
  
## 实验过程

* 在虚拟机上安装并配置好asciinema

  ```
  sudo apt-add-repository ppa:zanchey/asciinema

  sudo apt-get update

  sudo apt-get install asciinema
  ```

* 关联本地账号
  
  ```
  asciinema auth
  ```


## 录像

* [lesson1](https://asciinema.org/a/EcY3EDyWi3JWOWRxxsEHb4Zum)

* [lesson2](https://asciinema.org/a/LRH8aYASyaLKiyBG2yPUmNprY)

* [lesson3](https://asciinema.org/a/eR4xTwiYvNNRS72hBSxjE4u7R)

* [lesson4](https://asciinema.org/a/1S3F4SEWsXfIz1CZuuQrJgB2C)

* [lesson5](https://asciinema.org/a/nYpKpEvZavwR7LOjhB0PmxHxC)

* [lesson6](https://asciinema.org/a/17vjwXgUNp3NWu9YehExFuDoE)

* [lesson7](https://asciinema.org/a/JTJcj1nGWys9Bu8jsrV2F2hSr)


## vimtutor完成后的自查清单

* 你了解vim有哪几种工作模式？

  ```
  <esc> 正常模式  
  
  i或a 插入文本模式
  
  v 可视模式
  ```

* Normal模式下，从当前行开始，一次向下移动光标10行的操作方法？如何快速移动到文件开始行和结束行？如何快速跳转到文件中的第N行？
  
  ```
  一次向下移动光标10行  10j

  快速移动到文件开始行和结束行 gg和G

  快速跳转到文件中的第N行 NG
  ```

* Normal模式下，如何删除单个字符、单个单词、从当前光标位置一直删除到行尾、单行、当前行开始向下数N行？
  
  ```
  删除单个字符 x 

  删除单个单词 dw

  从当前光标位置一直删除到行尾 d$

  删除单行 dd

  删除当前行向下数N行 Ndd
  ```

* 如何在vim中快速插入N个空行？如何在vim中快速输入80个-？
  
  ```
  插入N个空行  N i <Esc>

  输入80个-    80 - i <Esc>
  ```

* 如何撤销最近一次编辑操作？如何重做最近一次被撤销的操作？

  ```
  撤销最近一次编辑操作 u

  重做最近一次被撤销的操作 CTRL+R
  ```

* vim中如何实现剪切粘贴单个字符？单个单词？单行？如何实现相似的复制粘贴操作呢？

  ```
  剪切粘贴单个字符  x+p
  
  单个单词 dw+p

  单行  dd+p

  相似的复制粘贴操作 先用dw剪切单个单词，再在原位置p恢复，然后在粘贴的地方p
  
  复制粘贴操作 v进入可视模式，移动光标选择粘贴内容，y复制文本，p粘贴文本
  ```

* 为了编辑一段文本你能想到哪几种操作方式（按键序列）？
  
  ```
  编辑文本 vim [文件名]

  在光标前插入 i 或 在光标后插入 a

  删除选中字符 x 或 d motion 删除字符、单词、单行等

  撤销最近一次操作 u  重做最近一次被撤销的操作 CTRL+R

  保存改动并退出 <ESC> :wq 或 不保存强制退出 <ESC> :q!
  ```

* 查看当前正在编辑的文件名的方法？查看当前光标所在行的行号的方法？
  
  ```
  CTRL+g
  ```

* 在文件中进行关键词搜索你会哪些方法？如何设置忽略大小写的情况下进行匹配搜索？如何将匹配的搜索结果进行高亮显示？如何对匹配到的关键词进行批量替换？
  
  ```
  在后面的文本中正向查找 <esc> :\keyword

  在前面的文本中反向查找 <esc> :?keyword

  同一方向查找下一个 n  相反方向查找下一个 N
  
  设置忽略大小写的情况下匹配  <ESC> :set ic

  匹配的搜索结果进行高亮显示  <ESC> :set hls is

  匹配到的关键词进行批量替换: 
  替换一行中的第一个字符 <ESC> :s/old/new 

  替换一行中的所有字符 <esc> :s/old/new/g

  替换m和n行间的所有字符 <esc> :m,n/old/new/g

  全文替换 <esc>:%s/old/new/g

  全文替换时，每一个都要询问，如要替换加c  <esc>:%s/old/new/gc

  ```

* 在文件中最近编辑过的位置来回快速跳转的方法？
  
  ```
  到上一次编辑的位置 CTRL+o

  到下一次编辑的位置 CTRL+i
  ```

* 如何把光标定位到各种括号的匹配项？例如：找到(, [, or {对应匹配的),], or }
  
  ```
  光标放在(, [, or {处，然后按%，即跳转到对应匹配的),], or }
  ```

* 在不退出vim的情况下执行一个外部程序的方法？
  
  ```
  <ESC> :!command
  ```

* 如何使用vim的内置帮助系统来查询一个内置默认快捷键的使用方法？如何在两个不同的分屏窗口中移动光标？

  ``` 
  使用vim的内置帮助系统来查询一个内置默认快捷键的使用方法: <esc>:help [快捷键名] <enter>
  
  在两个不同的分屏窗口中移动光标: CTRL+w
  ```

## 参考资料

[asciinema官网帮助文档](https://asciinema.org/docs/installation)