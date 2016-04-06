#/bin/bash
set -e

# Upgrade the system
sudo apt-get update
sudo apt-get upgrade -yy

# Install essentials
sudo apt-get install -yy xfsprogs emacs24-nox git zsh ruby redis-server

# Make sure we mount the /data partition, if one is available to us
grep LABEL=data1 /etc/fstab
if [ ${$?} == "1" ]
then
  sudo mkdir /mnt/data1
  echo "LABEL=data1    /mnt/data1      xfs  defaults  0 0" >> /etc/fstab
fi

# Make sure we mount the /local partition, if one is available to us
grep LABEL=local1 /etc/fstab
if [ ${$?} == "1" ]
then
  sudo mkdir /local
  echo "LABEL=local1    /local      xfs  defaults  0 0" >> /etc/fstab
fi

# Install mosh
sudo add-apt-repository ppa:keithw/mosh-dev -yy
sudo apt-get update
sudo apt-get install mosh -yy

# Install runurl
sudo add-apt-repository ppa:alestic/ppa -yy
sudo apt-get update -qq
sudo apt-get install -yy runurl

# Install latest version of nginx
wget --quiet -O - http://nginx.org/keys/nginx_signing.key | sudo apt-key add -
echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list
echo "deb-src http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list
sudo apt-get update
sudo apt-get install -yy nginx

# Install php-fpm
sudo apt-get install php5-fpm -yy

# Install Craft requirements
sudo apt-get install php5-mysql -yy
sudo apt-get install php5-imagick -yy
sudo apt-get install php5-curl -yy
sudo apt-get install php5-mcrypt -yy
php5enmod mcrypt

# Install LTS version of node.js
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install nodejs -yy

# Install global node modules
sudo npm install -g pm2

# Install Oracle Java
sudo add-apt-repository ppa:webupd8team/java -yy
sudo apt-get update
sudo apt-get install oracle-java8-installer -yy

# Install Elasticsearch
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
sudo apt-get update
sudo apt-get install elasticsearch -yy
sudo update-rc.d elasticsearch defaults 95 10

# Install latest version of Postgres
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
sudo apt-get update
sudo apt-get install -yy postgresql-9.5
sudo apt-get install -yy postgresql-contrib

# Install mysql
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password '
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password '
sudo apt-get -yy install mysql-server

# Install GlusterFS
sudo add-apt-repository ppa:gluster/glusterfs-3.6 -yy
sudo apt-get update
sudo apt-get install glusterfs-server -yy

