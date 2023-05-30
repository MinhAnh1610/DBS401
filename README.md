# Online library management system

|  OS | Backend |    Database   |
|:---:|:-------:|:-------------:|
| Any |   PHP   | MySQL/MariaDB |

> Source code from: https://phpgurukul.com/online-library-management-system/
---

## **⚙️ Installation**

### **1. Windows with XAMPP**

XAMPP in this instruction: [7.4.33-0-VC15](https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/7.4.33/xampp-portable-windows-x64-7.4.33-0-VC15.zip/download)

Make sure you started Apache & MySQL services on XAMPP Control Panel:

![image](https://github.com/MinhAnh1610/DBS401/assets/89181534/479b8db3-923a-4686-879e-cff0de69e472)

Copy `library` folder to `{XAMPP_ROOT_DIR}/htdocs/`:

![image](https://github.com/MinhAnh1610/DBS401/assets/89181534/296666dc-0a83-452c-a088-62f8c33e8921)

Go to `http://localhost/phpmyadmin/`, choose `Import` in navbar:

![image](https://github.com/MinhAnh1610/DBS401/assets/89181534/0c2d1f3f-cb47-477b-870f-f86880316fd4)

Select file `pma_import.sql.zip` to upload, then select `Import`:

![image](https://github.com/MinhAnh1610/DBS401/assets/89181534/7808c8fb-2c75-4784-af7d-5a5433bd3f57)

Wait a while for PMA to process:

![image](https://github.com/MinhAnh1610/DBS401/assets/89181534/21272ccc-965f-4cff-bdb2-3722ac6ec051)

Now we can access to the Web by `http://localhost/library/`:

![image](https://github.com/MinhAnh1610/DBS401/assets/89181534/8df1d313-1f55-4d7a-a00d-bbc6da4de540)

### **2. Linux**

In this instruction, we use Ubuntu 22.04.2 LTS with Apache 2.4.52, PHP 8.1.2 & MariaDB 10.6.12.

For requirements above, read this [instruction](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-22-04) to install and setup.

After finishing setting up all requirements, download or clone this repo, cd to folder, login to your MariaDB root account:

![image](https://github.com/MinhAnh1610/DBS401/assets/89181534/704d5bcd-3055-46e5-8db9-cf57240f5ee0)

In MariaDB console, type:

```console
source <path_to_library.sql>
```

![image](https://github.com/MinhAnh1610/DBS401/assets/89181534/de6a77e2-60fe-4adf-b3cd-e22dbd53d2fa)

Time to setup the Web folder:

Move `library` folder to WEBROOT:

```shell 
sudo mv library/ /var/www/html/
```

Set permission for web folder:

```shell
sudo chmod -R 755 /var/www/html/ && sudo chown -R www-data:www-data /var/www/html/ 
```

![image](https://github.com/MinhAnh1610/DBS401/assets/89181534/2e177fd5-abd8-4417-be7e-cb7c8f108f49)

Now we can access to the web same as Windows with XAMPP.

> Another way, much more easier, run `setup.sh` with root privileges.

---

## **🔐 Default credentials**

- Admin: `admin`/`Test@123`
- Student: `test@gmail.com`/`Test@123`
