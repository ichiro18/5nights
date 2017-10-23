#!/bin/bash

# MySQL root password
ROOTPASS='admin'
TIMEZONE='Europe/Moscow'

MYSQLPASS=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c12`
SFTPPASS=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c12`
PASSWORD=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c12`
##############

echo "Enter username for site and database:"
read USERNAME

echo "Enter domain"
read DOMAIN

##############

echo "Creating user and home directory..."
useradd $USERNAME -m -G sftp -s "/bin/false" -d "/app"
if [ "$?" -ne 0 ]; then
	echo "Can't add user"
	exit 1
fi
echo $SFTPPASS > ./tmp
echo $SFTPPASS >> ./tmp
cat ./tmp | passwd $USERNAME
rm ./tmp

##############

mkdir /app
mkdir /app/tmp
chmod -R 755 /app/
chown -R $USERNAME:$USERNAME /app/
chown root:root /app

echo "Creating vhost file"
echo "upstream backend-$USERNAME {server unix:/var/run/php5.6-$USERNAME.sock;}

server {
	listen				80;
	server_name			$DOMAIN www.$DOMAIN;
	root				/app/www;
	access_log			/app/vagrant/run/log/$USERNAME-access.log;
	error_log			/app/vagrant/run/log/$USERNAME-error.log;
	index				index.php index.html;
	rewrite_log			on;
	if (\$host != '$DOMAIN' ) {
		rewrite			^/(.*)$  http://$DOMAIN/\$1  permanent;
	}
	location ~* ^/core/ {
		deny			all;
	}
	location / {
		try_files		\$uri \$uri/ @rewrite;
	}
	location /index.html {
		rewrite			/ / permanent;
	}

	location ~ ^/(.*?)/index\.html$ {
		rewrite			^/(.*?)/ /$1/ permanent;
	}
	location @rewrite {
		rewrite			^/(.*)$ /index.php?q=\$1;
	}
	location ~ \.php$ {
		include			fastcgi_params;
		fastcgi_param	SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
		fastcgi_pass	backend-$USERNAME;
	}
	location ~* ^.+\.(jpg|jpeg|gif|css|png|js|ico|bmp)$ {
	   access_log		off;
	   expires			10d;
	   break;
	}
	location ~ /\.ht {
		deny			all;
	}
}
" > /etc/nginx/sites-available/$USERNAME.conf
ln -s /etc/nginx/sites-available/$USERNAME.conf /etc/nginx/sites-enabled/$USERNAME.conf

##############
echo "Creating php5.6-fpm config"

echo "[$USERNAME]

listen = /var/run/php5.6-$USERNAME.sock
listen.mode = 0666
user = $USERNAME
group = $USERNAME
chdir = /app

php_admin_value[upload_tmp_dir] = /app/tmp
php_admin_value[soap.wsdl_cache_dir] = /app/tmp
php_admin_value[upload_max_filesize] = 100M
php_admin_value[post_max_size] = 100M
php_admin_value[open_basedir] = /app/
#php_admin_value[disable_functions] = exec,passthru,shell_exec,system,proc_open,popen,curl_multi_exec,parse_ini_file,show_source,stream_socket_client,stream_set_write_buffer,stream_socket_sendto,highlight_file,com_load_typelib
php_admin_value[cgi.fix_pathinfo] = 0
php_admin_value[date.timezone] = $TIMEZONE
php_admin_value[session.gc_probability] = 1
php_admin_value[session.gc_divisor] = 100


pm = dynamic
pm.max_children = 10
pm.start_servers = 2
pm.min_spare_servers = 2
pm.max_spare_servers = 4
" > /etc/php/5.6/fpm/pool.d/$USERNAME.conf

##############

echo "Creating config.xml"
echo "<modx>
	<database_type>mysql</database_type>
	<database_server>localhost</database_server>
	<database>$USERNAME</database>
	<database_user>$USERNAME</database_user>
	<database_password>$MYSQLPASS</database_password>
	<database_connection_charset>utf8</database_connection_charset>
	<database_charset>utf8</database_charset>
	<database_collation>utf8_unicode_ci</database_collation>
	<table_prefix>modx_</table_prefix>
	<https_port>443</https_port>
	<http_host>$DOMAIN</http_host>
	<cache_disabled>0</cache_disabled>

	<inplace>1</inplace>

	<unpacked>0</unpacked>

	<language>ru</language>

	<cmsadmin>$USERNAME</cmsadmin>
	<cmspassword>$PASSWORD</cmspassword>
	<cmsadminemail>admin@$DOMAIN</cmsadminemail>

	<core_path>/app/core/</core_path>

	<context_mgr_path>/app/www/manager/</context_mgr_path>
	<context_mgr_url>/manager/</context_mgr_url>
	<context_connectors_path>/app/www/connectors/</context_connectors_path>
	<context_connectors_url>/connectors/</context_connectors_url>
	<context_web_path>/app/www/</context_web_path>
	<context_web_url>/</context_web_url>

	<remove_setup_directory>1</remove_setup_directory>
</modx>" > /app/config.xml

#############

echo "Reloading nginx"
service nginx reload
echo "Reloading php5.6-fpm"
service php5.6-fpm reload

##############

echo "Creating database"

Q1="CREATE DATABASE IF NOT EXISTS $USERNAME DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;;"
Q2="GRANT ALTER,DELETE,DROP,CREATE,INDEX,INSERT,SELECT,UPDATE,CREATE TEMPORARY TABLES,LOCK TABLES ON $USERNAME.* TO '$USERNAME'@'localhost' IDENTIFIED BY '$MYSQLPASS';"
Q3="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}"

mysql -uroot --password=$ROOTPASS -e "$SQL"

##############

echo "Installing MODx"

cd /app/www/

echo "Getting file from modx.com..."
sudo -u $USERNAME wget -O modx.zip http://modx.com/download/latest/
echo "Unzipping file..."
sudo -u $USERNAME unzip "./modx.zip" -d ./ > /dev/null

ZDIR=`ls -F | grep "\/" | head -1`
if [ "${ZDIR}" = "/" ]; then
		echo "Failed to find directory..."; exit
fi

if [ -d "${ZDIR}" ]; then
		cd ${ZDIR}
		echo "Moving out of temp dir..."
		sudo -u $USERNAME mv ./* ../
		cd ../
		rm -r "./${ZDIR}"

		echo "Removing zip file..."
		rm "./modx.zip"

		cd "setup"
		echo "Running setup..."
		sudo -u $USERNAME php ./index.php --installmode=new --config=/app/config.xml

		echo "Done!"
else
		echo "Failed to find directory: ${ZDIR}"
		exit
fi

echo "#!/bin/bash

echo \"Set permissions for /app/www...\";
echo \"CHOWN files...\";
chown -R $USERNAME:$USERNAME \"/app/www\";
echo \"CHMOD directories...\";
find \"/app/www\" -type d -exec chmod 0755 '{}' \;
echo \"CHMOD files...\";
find \"/app/www\" -type f -exec chmod 0644 '{}' \;
" > /app/chmod
chmod +x /app/chmod

echo "Done. Please visit http://$DOMAIN/manager/ to login.
Manager user: $USERNAME
Manager password: $PASSWORD
SFTP password: $SFTPPASS
Mysql password: $MYSQLPASS" > /app/pass.txt

cat /app/pass.txt