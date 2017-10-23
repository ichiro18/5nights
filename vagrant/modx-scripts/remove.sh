#!/bin/bash

ROOTPASS='admin'

echo "Enter username to delete:"
read USERNAME

mysql -uroot --password=$ROOTPASS -e "DROP USER $USERNAME@localhost"
mysql -uroot --password=$ROOTPASS -e "DROP DATABASE $USERNAME"
rm -f /etc/nginx/sites-enabled/$USERNAME.conf
rm -f /etc/nginx/sites-available/$USERNAME.conf
rm -f /etc/php/5.6/fpm/pool.d/$USERNAME.conf
find /var/log/nginx/ -type f -name "$USERNAME-*" -exec rm '{}' \;

service nginx reload
service php5.6-fpm reload

userdel -rf $USERNAME