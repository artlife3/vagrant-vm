# Firewall、SELinux OFF
/etc/rc.d/init.d/iptables stop
chkconfig iptables off
chkconfig ip6tables off
cp -p /etc/selinux/config /etc/selinux/config.orig
sed -i -e "s|^SELINUX=.*|SELINUX=disabled|" /etc/selinux/config


#Apache
sudo yum -y install httpd
sudo yum -y install mod_ssl
sudo /etc/init.d/httpd start
sudo chkconfig  httpd on


#MariaDB
sudo yum -y remove mariadb*
sudo rm -rf /var/lib/mysql/

#wget
sudo yum -y install wget

#vim
sudo yum -y install vim
#scm
sudo yum -y install git
sudo yum -y install svn
sudo yum -y install hg

#MySQL
yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
yum -y install mysql-community-server

chkconfig mysqld on
service mysqld start

mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* to user@\"%\" IDENTIFIED BY 'password' WITH GRANT OPTION;"
mysql -u root -e "FLUSH PRIVILEGES;"


#PHP
sudo yum -y install epel-release
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

sudo yum install -y --enablerepo=remi,remi-php56 php php-cli php-common php-devel php-gd \
php-intl php-mbstring php-pdo php-mysqlnd php-pear.noarch php-xml php-mcrypt

pecl install xdebug
sudo sed -i -e "/AddType text\/html \.php/i\AddType application\/x-httpd-php \.php \.html" /etc/httpd/conf.d/php.conf

# Composer
cd ~/
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

#Java
sudo yum install -y java-1.8.0-openjdk-devel.x86_64

#Elasitcsearch
useradd -c 'elasticsearch' -d /var/empty/elasticsearch -s /sbin/nologin elasticsearch
sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
cat << EOT > /etc/yum.repos.d/elastic.repo
[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOT
sudo yum install -y elasticsearch
sudo chkconfig --add elasticsearch
sed -i -e 's/2g/512m/g' /etc/elasticsearch/jvm.options
sudo -i service elasticsearch start

sudo /etc/init.d/httpd restart

#links
sudo yum -y install links
sudo yum -y install tree


# chmod
sudo chmod -R 777 /var/www/html

