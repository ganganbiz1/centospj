# centospj
```
centos6.10のイメージプル
docker pull --platform linux/amd64 centos:centos6
centos6.10のコンテナ起動
docker run --name centos6container -it --platform linux/amd64 centos:centos6 /bin/bash
```

1./etc/yum.repos.d/CentOS-Base.repoを編集
mirrorlistをコメントアウト、
baseurlのコメントアウトはずす。
その際、baseurlのvault.centos.orgに書き換え。
・参考
https://ex1.m-yabe.com/archives/5066

2.yum update
たぶん、成功するはず

3./etc/yum.repos.d/CentOS-Base.repoを編集
baseurlの箇所を以下みたいに編集
baseurl=http://vault.centos.org/6.5/os/x86_64/

・参考
https://wiki.inamuu.com/?CentOS6.5%E3%81%8B%E3%82%896.4%E3%81%B8%E3%81%AE%E3%83%80%E3%82%A6%E3%83%B3%E3%82%B0%E3%83%AC%E3%83%BC%E3%83%89%E6%89%8B%E9%A0%86

4.yum clean all
yum clean all実行

5.yum distribution-synchronization
yum distribution-synchronization
たぶんエラーでできない（依存関係で実行できない場合は）のがあるので、
```
rpm -e --nodeps パッケージ名
```
で解消
【例】
rpm -e --nodeps yum-plugin-ovl-1.1.30-42.el6_10.noarch

再度、yum distribution-synchronization

6.バージョン確認
cat /etc/redhat-release
```
[root@dd4365fa26d7 /]# cat /etc/redhat-release
CentOS release 6.5 (Final)
```

7.コンテナ抜ける
exitでただ抜けるだけ

8.イメージを作成
docker commit <container-name> <new-image-name>
【例】
docker commit centos6container centos6.5image

9.作成したイメージでコンテナ起動
docker run --name centos6.5container -it centos6.5image:latest /bin/bash

10.yumが使えるようにする（未確認）
/etc/yum.repos.d/CentOS-Base.repoのbaseurlをarchive.kernel.org/centos/6.5/XXXみたいに編集する
・例
baseurl=http://archive.kernel.org/centos/6.5/updates/$basearch/

11.yum install wget
```
Package does not match intended download. Suggestion: run yum --enablerepo=updates clean metadata
```
みたいなエラーが出たら、以下を試す
```
yum clean all
yum clean metadata
yum makecache
```

/etc/yum.repos.d/CentOS-Base.repoのvault.centos.orgをhttp://mirror.nsc.liu.se/centos-store/centos/$releasever/os/$basearch/みたいにすればいける

・参考
https://ateliee.com/archives/3946

12.apacheインストール
```
yum install httpd
```

13.Cのコンパイラ入れる（PHPのコンパイルに必要）
yum install gcc

14.php5.4をダウンロード
一旦、以下から適当に5.4をダウンロード
https://www.php.net/releases/

15.php5.4のソースをマウントしてコンテナ起動
```
docker run --name centos6-apache -it --platform linux/amd64 -v /Users/yuukiiwamoto/articleworkspaces/centospj/php:/usr/local/src centos6.5-apache2.2:latest /bin/bash
```

16.コンテナ内で解凍
```
cd /usr/local/src
tar -zxvf php-5.4.22.tar.bz2
cd php-5.4.22
./configure
make
make test
make install
php -v
```

PHPインストールに参考になりそうなサイト
https://qiita.com/fabula/items/8d03b2636f5dda856fff


