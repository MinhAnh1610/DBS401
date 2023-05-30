#!/bin/bash

# check if database 'library' & user 'library'@'localhost' are existed
# this will delete all data if existed
db_check() {
	db_name="library"
	user="library"
	host="localhost"
	database_exists=$(mysql -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='${db_name}';" --skip-column-names 2>/dev/null)
	user_exists=$(mysql -e "SELECT User FROM mysql.user WHERE User='${user}' AND Host='${host}';" --skip-column-names 2>/dev/null)
	[[ -n "${database_exists}" ]] && (mysql -e "DROP DATABASE ${db_name}")
	[[ -n "${user_exists}" ]] && (mysql -e "DROP USER '${user}'@'${host}';")
}

# check if mysql_secure_installation was executed before this script
# if not, run mysql_secure_installation as usual
msi() {
	config_file="/etc/mysql/my.cnf"
	[[ -f "${config_file}" ]] && 
	(db_check) || 
	( SECURE_MYSQL=$(expect -c "
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

	echo "$SECURE_MYSQL" )
}

# check for requirements if installed or not, and install missed package
requirements() {
	packages=("apache2" "mariadb-server" "expect" "php8.1" "libapache2-mod-php8.1" "php8.1-mysql")

	for package in "${packages[@]}"; do
    	dpkg -s "$package" &> /dev/null &&
		echo "- ${package} already installed!" ||
		( apt-get install -y $package && echo "- ${package} have been installed!" || echo "- Error: ${package} not installed!")
	done
	systemctl enable --now mariadb apache2
	systemctl restart apache2 mariadb
}

# setup db, setup web dir, this will clear all old data if existed.
setup() {
	web_root="/var/www/html"
	web_dir="/library"
	[[ -f "${web_root}${web_dir}" ]] && (rm -rf "${web_root}${web_dir}")
	msi &&
	mysql -u root -ptoor < library.sql &&
	cp -r library/ /var/www/html/ &&
	chmod -R 755 /var/www/html/ &&
	chown -R www-data:www-data /var/www/html/
}

main() {
	[ "$EUID" -ne 0 ] && (printf "[x] Not running with root privileges, please run this script again with root privileges!\n") ||
	(printf "[+] Installing requirements...\n" &&
	requirements > debug.log 2>&1  &&
	printf "[+] Setting up web application...\n" &&
	setup >> debug.log 2>&1) 
}

main && firefox localhost/library
