# 实验三

## 软件环境

* Ubuntu 18.04 Server 64bit

## 实验要求

* [Systemd 入门教程：命令篇 by 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)

* [Systemd 入门教程：实战篇 by 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html)

* 参照第2章作业的要求，完整实验操作过程通过asciinema进行录像并上传，文档通过github上传
  
## 录像

* [Systemd 入门教程：命令篇 3 ](https://asciinema.org/a/8Y9tD1NwJzxXHiF3jfz4q5wBE)

* [Systemd 入门教程：命令篇 4 ](https://asciinema.org/a/S52HqCdpEuAoooqRUSetQkSCP)

* [Systemd 入门教程：命令篇 5 ](https://asciinema.org/a/6p5T5rEhNAZWebvbZlJUaFmQt)

* [Systemd 入门教程：命令篇 6-7](https://asciinema.org/a/CIjpj1bheTsx8SFNOg2L2Mhwr)

* [Systemd 入门教程：实战篇 ](https://asciinema.org/a/yTDcXWbUdvWvivcEPrPBZ7GKz)

## 自查清单

* 如何添加一个用户并使其具备sudo执行程序的权限？

  ```
  sudo adduser username //在root权限下添加新用户

  sudo usermod -a -G sudo  username 或修改 /etc/sudoers文件添加‘username ALL=(ALL) ALL’//使其具备sudo执行程序的权限
  ```

* 如何将一个用户添加到一个用户组？
  
  ```
  usermod -a -G groupname username
  ```

* 如何查看当前系统的分区表和文件系统详细信息？
  
  ```
  df -h //查看文件系统详细信息

  sudo fdisk -l //查看当前系统的分区表

  sudo fadisk /dev/sda //查看sda磁盘设备的分区
  ```

* 如何实现开机自动挂载Virtualbox的共享目录分区？
  
  ```
  #在虚拟机设置-共享文件夹-右上角添加共享文件夹-勾选自动挂载和固定分配（此处选的共享文件夹是D:/1）

  #在虚拟机上创建共享目录  
  mkdir /mnt/share

  #实现挂载  
  mount -t vboxsf 1 /mnt/share

  ```

* 基于LVM（逻辑分卷管理）的分区如何实现动态扩容和缩减容量？

  ```
  #扩容
  lvextend -L +size /dev/vgtest/lvtest
  
  #缩减容量
  lvreduce -L -size /dev/vgqjc/lvqjc
  ```

* 如何通过systemd设置实现在网络连通时运行一个指定脚本，在网络断开时运行另一个脚本？
  
     * 在/usr/lib/systemd/system设置在网络联通时运行指定脚本SCRIPT1的配置文件
  
     ```
     [Unit]
     Description=run after network up
     after=network.target network-online.target

     [Service]
     ExecStart=EXE_SCRIPT1
     ...
     
     [Install]
     ...
  ```

     * 在/usr/lib/systemd/system设置在网络断开时运行指定脚本SCRIPT2的配置文件
  
     ```
     [Unit]
     Description=run before network up
     before=network.target network-online.target

     [Service]
     ExecStart=EXE_SCRIPT2
     ...
     
     [Install]
     ...
     ```
  
     * 重新加载配置文件
    ```
    sudo systemctl daemon-reload
    ````

* 如何通过systemd设置实现一个脚本在任何情况下被杀死之后会立即重新启动？实现杀不死？

     * 在/usr/lib/systemd/system设置相关配置文件

     ```
     ...
     [service]
     ...
     Restart=always
     ...
     ```

     * 重新加载配置文件
     ```
     sudo systemctl daemon-reload
     ````
     
## 参考资料

[VirtualBox 共享文件夹设置 及 开机自动挂载](https://blog.csdn.net/ysh198554/article/details/73335844)

[虚拟机VirtualBox 共享挂载问题：mount: /mnt/xxx: wrong fs type, bad option, bad superblock on xxx...](https://blog.csdn.net/weixin_34138255/article/details/91899738)

[linux LVM逻辑卷的创建,扩容，缩减和删除](https://blog.csdn.net/qq_27281257/article/details/81603410)