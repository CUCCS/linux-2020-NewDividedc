# 第一章：Linux基础（实验）
## 软件环境
##### ·Virtualbox
##### ·Ubuntu 18.04 Server 64bit 

## 实验问题
##### ·如何配置无人值守安装iso并在Virtualbox中完成自动化安装。

##### ·Virtualbox安装完Ubuntu之后新添加的网卡如何实现系统开机自动启用和自动获取IP？

##### ·如何使用sftp在虚拟机和宿主机之间传输文件？

## 实验过程

#### 1.Virtualbox安装完Ubuntu之后新添加的网卡如何实现系统开机自动启用和自动获取IP
   a.添加第二块Host-Only网卡
   
   ![添加HOST-ONLY网卡](/img/网卡/0.PNG)

   b.修改\etc\netplan\01-nctcfg.yaml

  
   ![修改文档1](/img/网卡/1.PNG)
  
   ![修改文档2](/img/网卡/2.PNG)
  
   ![修改文档3](/img/网卡/3.PNG)

   c.重新启用系统后,查看ip，网卡开启

   ![重启后查看ip](/img/网卡/4.PNG)

#### 2.如何使用sftp在虚拟机和宿主机之间传输文件？
   a.使用putty连接虚拟机

   ![putty连接虚拟机](/img/传输文件/1.PNG)

   b.使用psftp连接虚拟机，并从宿主机传输ubuntu镜像文件到虚拟机

   ![使用psftp传输文件](/img/传输文件/2.PNG)

#### 3.如何配置无人值守安装iso并在Virtualbox中完成自动化安装

   #在当前用户目录下（/home/newdividedc）创建一个用于挂载iso镜像文件的目录

   ![创建挂载挂载镜像文件的目录](/img/无人值守/1.PNG)
  
   #挂载iso镜像文件到该目录
  
   ![挂载](/img/无人值守/2.PNG)
  
   #创建一个工作目录用于克隆光盘内容并且同步光盘内容到目标工作目录
  
   ![创建cd目录](/img/无人值守/3.PNG)
  
   ![克隆光盘内容](/img/无人值守/4.PNG)
  
   #卸载iso镜像
  
   ![卸载iso镜像](/img/无人值守/5.PNG)
  
   #进入目标工作目录
  
   ![进入cd目录](/img/无人值守/6.PNG)
  
   #编辑Ubuntu安装引导界面增加一个新菜单项入口
  
   ![编辑Ubuntu安装引导界面增加一个新菜单项入口](/img/无人值守/7.PNG)
  
   #添加以下内容到该文件后强制保存退出（而后更改为添加到文首）
  
   ![在文档首部添加内容](/img/无人值守/8.PNG)
  
   #从宿主机上传ubuntu-sever-autoinstall.seed到/home/newdividedc/cd/preceed
  
   ![上传镜像文件到虚拟机](/img/无人值守/9.PNG)
  
   #修改isolinux/isolinux.cfg，更改timeout 0为timeout 10（可选，否则需要手动按下ENTER启动安装界面） 
  
   ![修改isolinux/isolinux.cfg](/img/无人值守/10.PNG)
   ![](img/无人值守/11.PNG)
  
   #重新生成md5sum.txt
  
   ![](img/无人值守/12.PNG)
  
   #封闭改动后的目录到.iso
  
   ![](img/无人值守/13.PNG)
  
   #查看cd目录，已有生成的custom.iso，将其通过psftp传输到宿主机
  
   ![](/img/无人值守/14.PNG)
   ![](/img/无人值守/15.PNG)
   ![](/img/无人值守/16.PNG)
  
   #自动安装过程
  
   ![](/img/无人值守/17.PNG)
   ![](/img/无人值守/18.PNG)
   ![](/img/无人值守/19.PNG)
   ![](/img/无人值守/20.PNG)
  
   #安装成功
  
   ![](/img/无人值守/21.PNG)
   ![](/img/无人值守/22.PNG)
   ![](/img/无人值守/23.PNG)
   ![](/img/无人值守/24.PNG)

## 参考资料：
 [1.老师b站补丁视频](https://www.bilibili.com/video/av95931311/?p=2&t=1326)
 
 [2.无人值守Linux安装镜像制作](https://blog.csdn.net/qq_31989521/article/details/58600426)
 
 [3.windows下用putty上传文件到远程linux服务器](https://blog.csdn.net/wuzuyu365/article/details/67640043)

## 实现特性
   定制一个普通用户名和默认密码

   ![定制密码](/img/无人值守/定制密码.PNG)
   
   定制安装OpenSSH Server
   
   安装过程禁止自动联网更新软件包
   
   ![定制openssh和禁止自动联网更新](/img/无人值守/定制openssh.PNG)
   
   参考资料：[往届师哥作业](https://github.com/CUCCS/linux/blob/master/2017-1/snRNA/ex1/无人值守Linux安装镜像制作.md)
## 实验遇到的问题及解决方法
   1.以为挂载光盘失败

   ![](/img/无人值守/挂载光盘失败.PNG)
   
   ![](/img/无人值守/挂载光盘失败解决.PNG)
   
   [参考资料](https://zhidao.baidu.com/question/224592291.html?qbl=relate_question_0)
   
   2.使用psftp传输镜像文件到虚拟机上时，出现“permission denied”，上传失败。使用chmod 777命令给目标文件权限以后，上传成功。
   
   ![](/img/传输文件/无法传输.PNG)
   
   [参考资料](https://blog.csdn.net/sihai12345/article/details/79370405)
   
   3.使用mkisofs命令制作镜像文件后，出现错误提示。按照提示更新安装相应软件包后成功。
   
   [参考资料](https://blog.csdn.net/qq_31989521/article/details/58600426)