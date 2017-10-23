https://modx.pro/hosting/678-the-right-hosting-for-modx-revolution-2/

В /etc/ssh/sshd_config

— Меняем PermitRootLogin no

— Комментируем #Subsystem sftp /usr/lib/openssh/sftp-server

— Добавляем в конец


Subsystem sftp internal-sftp

``
Match Group sftp
	ChrootDirectory %h
	AllowTCPForwarding no
	ForceCommand internal-sftp
``
admin
siteadmin

Manager user: 5nights
Manager password: tV0qCE70x8CA
SFTP password: Dt_GgH4jAJDg
Mysql password: 42_Jjj9DwuxG
