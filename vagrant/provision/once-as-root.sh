#!/usr/bin/env bash

#== Import script args ==

timezone=$(echo "$1")

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"

export DEBIAN_FRONTEND=noninteractive

info "Configure timezone"
timedatectl set-timezone ${timezone} --no-ask-password
echo "Done!"

info "Update OS software"
apt-get update
apt-get upgrade -y
echo "Done!"

info "Config SSH"
sh ./config-ssh.sh
addgroup sftp
echo "Done!"

info "Prepare root password for MySQL"
debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password \"''\""
debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password \"''\""
echo "Done!"

info "Install Packages"
apt-get install -y python-software-properties
add-apt-repository ppa:nginx/stable
apt-get update
add-apt-repository ppa:ondrej/php -y
apt-get install -y php5.6 php5.6-fpm php5.6-mcrypt php5.6-mysql php5.6-curl php5.6-db php5.6-gd
apt-get install -y nginx mysql-server unzip zip sendmail htop
echo "Done!"