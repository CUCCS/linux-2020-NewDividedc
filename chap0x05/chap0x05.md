# 第五章：Web服务器（实验）

## 实验环境

* Nginx

* VeryNginx

* Wordpress 
  
  * WordPress 4.7

* Damn Vulnerable Web Application (DVWA)

## 实验过程

* 在一台主机（虚拟机）上同时配置Nginx和VeryNginx

   ```
   #安装nginx
   sudo apt install nginx


   #安装verynginx
   git clone https://github.com/alexazhou/VeryNginx.git
   sudo apt install libssl-dev libpcre3 libpcre3-dev build-essential
   sudo apt install python
   cd VeryNginx
   python install.py install
   ```

   * 安装VeryNginx过程中出现错误

   ![安装VeryNginx出现错误](\image\安装VeryNginx出现错误.PNG)

   ```
   #需要安装zlib-devel
   wget http://www.zlib.net/zlib-1.2.11.tar.gz
   tar -xzvf zlib-1.2.11.tar.gz
   cd zlib-1.2.11
   ./configure
   make
   sudo make install

   #重新安装VeryNginx
   cd VeryNginx
   python install.py install
   ```

   * 修改VeryNginx配置文件，修改用户名和监听端口

   ```
   cd /opt/verynginx/openresty/nginx/conf
   sudo vim nginx.conf
   ```

   ![修改VeryNginx配置文件中的用户名](\image\修改VeryNginx用户名.PNG)

   ![修改VeryNginx配置文件中的用户监听端口](\image\修改VeryNginx监听端口.PNG)

   * 启动VeryNginx服务
 
   ```
   #查看Nginx进程信息，获得进程号位721
   ps -ef | grep nginx

   #杀死Nginx进程
   sudo kill -QUIT 721

   #启动VeryNginx服务
   sudo /opt/verynginx/openresty/nginx/sbin/nginx
   ```

   * 修改Nginx配置文件，修改监听端口为8080

   ```
   sudo vim /etc/nginx/sites-available/default
   ```

   ![修改Nginx监听端口](\image\修改Nginx监听端口.PNG)

   * 启动Nginx服务
  
   ```
   sudo service nginx start
   ```

   * 访问VeryNginx和Nginx成功
  
   ![访问80端口](\image\访问80端口成功.PNG)

   ![访问VeryNginx成功](\image\访问VeryNginx成功.PNG)

   ![访问nginx成功](\image\访问nginx成功.PNG)

   * PHP-FPM进程的反向代理配置在nginx服务器上
   
   ```
   #安装mysql
   sudo apt install mysql-server

   #安装php-fpm模块以及一个附加的帮助程序包php-mysql
   sudo apt install php-fpm php-mysql

   #修改/etc/nginx/sites-enabled/default文件
   sudo vim /etc/nginx/sites-enabled/default

   location ~ \.php$ {
         include snippets/fastcgi-php.conf;
          fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
     }

   #重新启动nginx
    sudo systemctl restart nginx
   ```

* 使用Wordpress搭建的站点对外提供访问的地址为：http://wp.sec.cuc.edu.cn
   
   * 创建一个数据库wordpress和一个供WordPress使用的用户wordpressuser
  
   ```
   #登录mysql
   mysql -u root -p

   #创建wordpress数据库
   CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

   #创建wordpressuser用户
   GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';

   #刷新权限
   FLUSH PRIVILEGES;

   #退出mysql
   exit；
   ```
   
   * 配置php
  
   ```
   #安装php扩展
   sudo apt update
   sudo apt install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

   #重新启动php-fpm
   sudo systemctl restart php7.2-fpm
   ```

   * 安装并配置wordpress
     
   ```
   #进入可写目录安装wordperss
   cd /tmp
   wget https://github.com/WordPress/WordPress/archive/4.7.zip
   
   #解压文件
   unzip 4.7.zip

   #将示例配置文件复制到WordPress实际读取的文件中
   /tmp$ cp /tmp/WordPress-4.7/wp-config-sample.php /tmp/WordPress-4.7/wp-config.php
   
   #将目录的全部内容复制到文档根目录中
   sudo cp -a /tmp/WordPress-4.7/. /var/www/html/wordpress

   #赋予/var/www/html可执行权限，否则不会进入WordPress的index.php页面
   sudo chmod -R 777 /var/www/html/wordpress

   #从WordPress密钥生成器中获取安全值
   curl -s https://api.wordpress.org/secret-key/1.1/salt/
   ```
   
   * 将生成内容复制到/var/www/html/wordpress/wp-config.php，并修改数据库相关数据
   
   ![修改wp-config.php文件](\image\修改wp-config.php文件.PNG)

   * 修改nginx配置文件

   ```
   sudo vim /etc/nginx/sites-enabled/default
   #修改根访问目录
   root /var/www/html/wordpress;
   #重新加载nginx
   sudo systemctl reload nginx
   ```
   
   * 实现用域名http://wp.sec.cuc.edu.cn访问
   
   ```
   #修改/etc/nginx/sites-available/default的server_name
   server_name wp.sec.cuc.edu.cn;

   #在虚拟机的/etc/hosts和本机C:\Windows\System32\drivers\etc\hosts添加以下内容
   192.168.56.101 wp.sec.cuc.edu.cn
   ```

   * wordpress使用域名访问成功
   
   ![wordpress使用域名访问成功](\image\wordpress使用域名访问成功.PNG)

* 使用Damn Vulnerable Web Application (DVWA)搭建的站点对外提供访问的地址为： http://dvwa.sec.cuc.edu.cn
    
   * 下载DVWA
   
   ```
   #安装DVWA
   sudo git clone https://github.com/ethicalhack3r/DVWA

   #把下载的文件放入/var/www/html/文件夹下
   sudo mv /tmp/DVWA /var/www/html

   #将DVWA中的/config/config.inc.php.dist重命名为/config/config.inc.php
   sudo cp /var/www/html/DVWA/config/config.inc.php.dist /var/www/html/DVWA/config/config.inc.php
   ```

   * 配置mysql
   
   ```
   #登录mysql新建数据库DVWA和用户dvwauser，刷新权限
   CREATE DATABASE dvwa DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
   GRANT ALL ON dvwa.* TO 'dvwauser'@'localhost' IDENTIFIED BY 'p@ssw0rd';
   FLUSH PRIVILEGES;
   EXIT;

   #重启mysql生效
   sudo systemctl restart mysql

   #修改DWVA配置文件
   sudo vim /var/www/html/DVWA/config/config.inc.php

   $_DVWA[ 'db_server' ]   = '127.0.0.1';
   $_DVWA[ 'db_database' ] = 'dvwa';
   $_DVWA[ 'db_user' ]     = 'dvwauser';
   $_DVWA[ 'db_password' ] = 'p@ssw0rd';
   ```

   * 配置php
   
   ```
   #修改php配置文件
   sudo vim /etc/php/7.2/fpm/php.ini

   #修改以下内容
   allow_url_include = on
   allow_url_fopen = on
   safe_mode = off
   magic_quotes_gpc = off
   display_errors = off

   #重启php-fpm
   sudo systemctl restart php7.2-fpm
   ```

   * 设置DVWA文件夹访问权限

   ```
   sudo chown -R www-data.www-data /var/www/html/DVWA
   ```

   * 配置DVWA的的监听模块，监听端口为8081
   
   ```
   # 在/etc/nginx/sites-available/default中增加以下内容并保存
   server {
        listen 8081;
        listen [::]:8081;

        server_name dvwa.sec.cuc.edu.cn;

        root /var/www/html/DVWA;
        index index.html setup.php index.htm index.php index.nginx-debian.html;
        location / {
                try_files $uri $uri/ =404;
          }
        #配置php-fpm反向代理
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        }
    }
    #重启nginx
    sudo systemctl restart nginx
   ```

   * 访问dvwa成功
   
   ![访问dvwa成功](\image\访问dvwa成功.PNG)

   * 配置域名为http://dvwa.sec.cuc.edu.cn
   
   ![dvwa使用域名访问成功](\image\dvwa使用域名访问成功.PNG)
   
   ![dvwa登陆成功](\image\dvwa登陆成功.PNG)

* VeryNginx作为本次实验的Web App的反向代理服务器和WAF
   
   * 在verynginx中配置matcher、upstream和proxy pass
   
   ![在verynginx中配置matcher](\image\在verynginx中配置matcher.PNG)

   ![verynginx配置upstream和proxyPass](\image\verynginx配置upstream和proxyPass.PNG)

* 安全加固要求
    
   * 使用IP地址方式均无法访问上述任意站点，并向访客展示自定义的友好错误提示信息页面-1
      
      * 添加matcher 

      ![使用ip无法访问—修改matcher](\image\使用ip无法访问—修改matcher.PNG)

      * 添加response

      ![使用ip无法访问—添加response](\image\使用ip无法访问—添加response.PNG) 

      * 添加filter
      
      ![使用ip无法访问—添加filter](\image\使用ip无法访问—添加filter.PNG)  

      * 使用ip无法访问
      
      ![使用ip无法访问](\image\使用ip无法访问.PNG)  

   * Damn Vulnerable Web Application (DVWA)只允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的友好错误提示信息页面-2
      
      * 添加matcher
      
      ![dvwa白名单添加matcher](\image\dvwa白名单添加matcher.PNG)

      * 添加response

      ![dvwa白名单添加response](\image\dvwa白名单添加response.PNG)

      * 添加filter

      ![dvwa白名单添加filter](\image\dvwa白名单添加filter.PNG)  

      * 在白名单中的ip访问成功
      
      ![dvwa白名单访问成功](\image\dvwa白名单访问成功.PNG)

      * 未在白名单中的ip地址访问失败

      ![未在dvwa白名单访问失败](\image\未在dvwa白名单访问失败.PNG) 
   
   * 在不升级Wordpress版本的情况下，通过定制VeryNginx的访问控制策略规则，热修复WordPress < 4.7.1 - Username Enumeration

      *  添加matcher
      ![NameEnumeration添加matcher](\image\NameEnumeration添加matcher.PNG)

      * 添加filter
       
      ![NameEnumeration添加filter](\image\NameEnumeration添加filter.PNG)

      * 修改后访问失败，返回404
       
      ![NameEnumeration修改后访问](\image\NameEnumeration修改后访问.PNG)  

   * 通过配置VeryNginx的Filter规则实现对Damn Vulnerable Web Application (DVWA)的SQL注入实验在低安全等级条件下进行防护 
   
      * 添加matcher
      
      ![sql添加matcher](\image\sql添加matcher.PNG)    

      * 添加response

      ![sql添加response](\image\sql添加response.PNG)

      * 添加filter

      ![sql添加filter](\image\sql添加filter.PNG)

      * 测试结果 
      
      ![sql访问失败](\image\sql访问失败.PNG)

* VeryNginx配置要求

   * VeryNginx的Web管理页面仅允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的友好错误提示信息页面-3

      * 添加matcher
      
      ![VeryNginx白名单添加matcher](\image\VeryNginx白名单添加matcher.PNG)

      * 添加response

      ![VeryNginx白名单添加response](\image\VeryNginx白名单添加response.PNG)

      * 添加filter

      ![VeryNginx白名单添加filter](\image\VeryNginx白名单添加filter.PNG)  

      * 在白名单中的ip访问成功
      
      ![VeryNginx白名单访问成功](\image\VeryNginx白名单访问成功.PNG)

      * 未在白名单中的ip地址访问失败

      ![VeryNginx未在白名单访问失败](\image\未在VeryNginx白名单访问失败.PNG) 

   * 通过定制VeryNginx的访问控制策略规则实现：
      
      * 限制DVWA站点的单IP访问速率为每秒请求数 < 50
      
      * 限制Wordpress站点的单IP访问速率为每秒请求数 < 20
      
      * 超过访问频率限制的请求直接返回自定义错误提示信息页面-4     
      
         * 添加response

         ![添加频率限制response](\image\添加频率限制response.PNG) 

         * 添加频率限制信息

         ![添加频率限制](\image\添加频率限制.PNG) 

         * 访问结果

         ![dvwa访问频率](\image\dvwa访问频率.PNG)

         ![wp访问频率](\image\wp访问频率.PNG)

   * 禁止curl访问
   
      * 添加matcher
      
      ![curl添加matcher](\image\curl添加matcher.PNG)

      * 添加response
      
      ![curl添加response](\image\curl添加response.PNG)

      * 添加filter
      
      ![curl添加filter](\image\curl添加filter.PNG)

      * curl结果
       
      ![curl失败](\image\curl失败.PNG)

## 参考资料

[Ubuntu Nginx ./configure: error: the HTTP gzip module requires the zlib library. You can either...](https://blog.csdn.net/the_wish/article/details/52057921)

[linux-2019-Cassie8888](https://github.com/CUCCS/linux-2019-Cassie8888/blob/linux_05/linux05/实验五.md)

[linux-2019-jackcily](https://github.com/CUCCS/linux-2019-jackcily/blob/job5/job5/实验5.md)

[How To Install WordPress with LEMP on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lemp-on-ubuntu-18-04)

[How To Install Linux, Nginx, MySQL, PHP (LEMP stack) on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-ubuntu-18-04)
