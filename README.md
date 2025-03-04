# whatweb-plus 

whatweb-plus 是基于国际通用的 Whatweb 优化改造的国内版Web指纹识别工具。

主体程序:
https://github.com/winezer0/whatweb-plus

插件存储:
https://github.com/winezer0/whatweb-plus-plugins

原始项目:
https://github.com/urbanadventurer/WhatWeb


# TODO

```
日常:
对指纹扫描插件进行分类规划，主要是进行指纹文件规划和规则合并整理。
```

# 功能支持

```
1、多种插件分类和加载方案：
    1、支持多级目录插件分类和加载.[新增]
    2、支持按插件名称 指定加载、 [原生]
    3、支持按插件目录 指定加载、 [原生]
2、最小化重复目标请求.          [新增]
3、提供exe程序直接运行.         [新增]
4、优化插件加载目录设置：
  默认加载插件路径：
    1、当前命令行环境路径.      [新增]
    2、whatweb.exe及 whatweb.rb 路径. [新增]
    3、lib目录的相对路径的上一级.             [默认]
    4、Windows下的用户目录下的whatweb目录.    [新增]
    5、Linux下的用户目录下的whatweb目录.      [新增]
    6、linux自己安装的/opt/whatweb 目录.     [新增]
    7、Kali默认安装的/usr/share/whatweb     [默认]
  注意：默认加载插件路径下的plugins或my-plugins目录.   [优化]
  注意：建议同时只使用一种默认路径方式,以免插件重复.

5、支持对输入的域名,同时添加http和https协议头进行测试.   [优化]

```



# 最近更新

    20230427 更新whatweb VERSION = 0.5.5.14 ,合并最新版本代码, 优化插件加载目录配置
        1 合并whatweb目前最新代码，增加了几种匹配位置
          when 'uri.path'  # 合并whatweb新增位置
            search_context = target.uri.path 
          when 'uri.query'   # 合并whatweb新增位置
            search_context = target.uri.query
          when 'uri.extension'   # 合并whatweb新增位置
            search_context = target.uri.path.scan(/\.(\w{3,6})$/).flatten.first
    
        2 优化自动加载默认插件路径，让exe下也能够自动加载插件
        3 支持多层子目录插件自动加载, 无三层插件加载限制.
        4 内存重复扫描过滤阈值设定为9999,超出阈值清空.



历史更新记录: [更新记录](doc/更新记录.md)



# 新增参数

```
-Z --no-base-path
    新增，关闭自动访问高频指纹路径，默认True,  建议根据使用条件关闭
    whatweb-plus 默认会请求几个内置指纹路径,表现为每个目标都会额外多出几个请求。

-Y --no-min-urls
    新增，关闭最小化访问插件:url，默认True
    whatweb-plus 默认会将匹配插件的每一个请求URL作为完整的新URL作为请求，以避免全局重复请求相同的URL
    缺点是会表现出一个站点的多个子请求，建议使用novafinger.py包装器的--log-csv参数进行结果输出，便于排序处理

-X  --no-max-match
    新增，忽略匹配:url要求，默认True , 不建议关闭 
    whatweb-plus 匹配规则时,默认会忽略:url需要相同的前提，形成更多的结果匹配，需要高精度的匹配时可以开启
```



# 注意事项

```
1.关于运行环境
    使用ruby运行whatweb脚本，需要安装mmh3模块 [gem install mmh3]
    windows下有exe打包版本，其他系统未打包成功，需要安装ruby环境（kali ruby2.5-2.7 测试通过） 
    whatweb.exe为了缩小打包体积，仅包含简单的基础插件

2.关于WAF指纹识别
	支持WAf指纹，但没有添加会触发waf的请求,需要用户主动请求会触发waf的请求.
	如 whatweb http://www.baidu.com/index?/etc/passed
```

# 程序安装

## ruby环境需求

```
运行whatweb需要ruby2.3及以上环境
ruby2.7环境下运行测试通过。

ruby2.0.0 版本报错记录:
Fetching: bundler-2.3.11.gem (100%)
ERROR:  Error installing bundle:
        bundler requires Ruby version >= 2.3.0.
```



## windows环境安装ruby

```
参考:
Ruby and Whatweb Install on Windows
https://mp.weixin.qq.com/s/ZjQfsovGP-GK_xUYuP7M-A

windows下可以直接使用打包好的EXE程序,但相比直接使用ruby调用会慢一些。
```

## centOS7 环境安装ruby

```
kali系统下多次尝试打包linux下的可执行文件失败了，有兴趣的朋友可以看看ruby-packer这个项目，猜测可以使用ubuntu进行打包。

参考:
CentOS7安装最新版ruby
https://blog.csdn.net/NetRookieX/article/details/108308734

centos7下直接通过yum安装的ruby2.0版本太低。
centos7下测试使用rvm安装ruby比较复杂。
因此建议centos7下使用源码安装 

下载ruby源代码
http://www.ruby-lang.org/en/downloads/
https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.6.tar.gz

安装ruby环境依赖包
yum -y install gcc openssl-devel make

编译ruby环境
tar -xvf ruby-2.7.6.tar.gz 
cd ruby-2.7.6/
./configure --prefix=/usr/local/ruby
make && make install
rm -rf ruby-2.7.6* #可选


添加环境变量
echo "PATH=$PATH:/usr/local/ruby/bin" >> /etc/bashrc
source /etc/bashrc

运行测试
ruby -v           #2.7.6
gem -v            #3.1.6

PS：如果gem不存在 yum install gem

替换gem源
#查看当前源,如果是国内源可以忽略以下操作
gem sources -l		
#增加源
gem sources -a  http://mirrors.aliyun.com/rubygems/
或
#gem sources -a http://gems.ruby-china.com/   
#删除原有源
gem sources --remove https://rubygems.org/     
```

## Linux安装whatweb

```
上传解压
unzip WhatWeb*.zip
mv  WhatWeb whatweb
cd whatweb
chmod +x whatweb

安装bundle
gem install bundle

#更新Bundler  [可选]
#bundle update

批量安装依赖
bundle install
gem install mmh3 
PS：由于mmh3是后面修改的,所以bundle不一定会自动安装,此时需要手动安装

运行测试
whatweb -v     #WhatWeb version 0.5.5.12
whatweb www.baidu.com -X -Y -Z

快捷运行配置--弃用
apt-get remove whatweb #卸载kali whatweb可选
mv whatweb /opt/whatweb  【默认自定义目录】
ln -s  /opt/whatweb/whatweb /usr/bin

快捷运行配置--更优的解决方案
cp whatweb whatweb+
mv whatweb /opt/whatweb  【默认自定义目录】
ln -s  /opt/whatweb/whatweb+ /usr/bin
whatweb+ www.baidu.com -X -Y -Z
```



## Kali安装whatweb

```
上传解压
unzip WhatWeb*.zip
mv  WhatWeb whatweb
cd whatweb
chmod +x whatweb

安装mmh3依赖库
gem install mmh3 

运行测试
whatweb -v     #WhatWeb version 0.5.5.12
whatweb www.baidu.com -X -Y -Z

快捷运行配置--更优的解决方案
cp whatweb whatweb+
mv whatweb /opt/whatweb 【自定义目录】
ln -s  /opt/whatweb/whatweb+ /usr/bin
whatweb+ www.baidu.com -X -Y -Z
```

# 工具使用说明

Whatweb 0.5.5.12 完善使用及插件文档【非常重要,记录各种功能更新及基本使用】

https://mp.weixin.qq.com/s/F9sXIhCfFCZ3WtMMltnP5Q

痛点重谈-Web指纹识别与解决方案-NOVASEC

https://mp.weixin.qq.com/s/lHIJmIWbm8ylK6yjjmmNkg

Whatweb特征修改、插件编写、EXE打包

https://mp.weixin.qq.com/s/TaYHrzw5Yb6jxj046nR_DA

NOVASEC 开源工具记录

https://mp.weixin.qq.com/s/h4rYBZ36xaEHF34vyW4WQg

里程碑思路: Go工具框架实现动态插件

https://mp.weixin.qq.com/s/ihNalwYQGNcWlG7TJ8yazw

whatweb增强版公开发布

https://mp.weixin.qq.com/s/njxWqxw-TJH2MKAvOvI-kg



# NEED STAR And ISSUE

```
1、右上角点击Star支持更新.
2、ISSUE或NOVASEC提更新需求
```

![NOVASEC](doc/NOVASEC.jpg)
