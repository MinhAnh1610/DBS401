#!/bin/bash

msi() {
	SECURE_MYSQL=$(expect -c "
	set timeout 10
	spawn mysql_secure_installation

	expect \"Enter current password for root (enter for none):\"
	send \"\r\"
	
	expect \"Switch to unix_socket authentication\"
	send \"n\r\"

	expect \"Set root password?\"
	send \"Y\r\"

	expect \"New password:\"
	send \"toor\r\"

	expect \"Re-enter new password:\"
	send \"toor\r\"

	expect \"Remove anonymous users?\"
	send \"Y\r\"

	expect \"Disallow root login remotely?\"
	send \"Y\r\"

	expect \"Remove test database and access to it?\"
	send \"Y\r\"

	expect \"Reload privilege tables now?\"
	send \"Y\r\"

	expect eof
	")

	echo "$SECURE_MYSQL"
}

requirements() {
	apt-get update -y &&
	apt-get -y install apache2 mariadb-server &&
	systemctl enable --now mariadb apache2 &&
	msi &&
	apt-get install -y 	php8.1 libapache2-mod-php8.1 php8.1-mysql php8.1-mysqli &&
	systemctl restart apache2
}


setup() {
	mysql -u root -ptoor < library.sql &&
	cp library/ /var/www/html/ &&
	chmod -R 755 /var/www/html/ &&
	chown -R www-data:www-data /var/www/html/
}

main() {
	[ "$EUID" -ne 0 ] && (printf "[x] Not running with root privileges, please run this script again with root privileges!\n") ||
	
	(
	printf "[+] Installing requirements...\n" &&
	requirements &&
	printf "[+] Setting up web application...\n" &&
	setup
	) 
}

main

