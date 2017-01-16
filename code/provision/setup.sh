echo "Updating system"
apt-get update &>/dev/null
apt-get upgrade -y &>/dev/null
apt-get install python-software-properties build-essential -y &>/dev/null
apt-get install curl &>/dev/null

mkdir -p /usr/local/bin
curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
chmod a+x /usr/local/bin/symfony

systemctl stop apache2 &>/dev/null
systemctl disable apache2 &>/dev/null
apt remove apache2 &>/dev/null

echo "Install git"
apt-get install git -y &>/dev/null

echo "Install ru language"
apt-get install language-pack-ru -y &>/dev/null

echo "Install nginx"
apt-get install nginx -y &>/dev/null

echo "Install MariaDB"
apt-get install software-properties-common -y &>/dev/null
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 &>/dev/null
add-apt-repository -y 'deb [arch=amd64,i386] http://mirrors.hustunique.com/mariadb/repo/10.1/ubuntu xenial main' &>/dev/null
apt-get update &>/dev/null

apt-get install mariadb-server-10.0 -y &>/dev/null

echo "Configure MariaDB"
mysql -p -e "CREATE DATABASE symfony; CREATE USER 'symfony'@'%' IDENTIFIED BY 'symfony'; GRANT ALL PRIVILEGES ON symfony.* TO 'symfony'@'%'; GRANT ALL PRIVILEGES ON symfony.* TO 'symfony'@'10.4.4.1'; FLUSH PRIVILEGES;"

echo "Install PHP 7.1"
add-apt-repository -y ppa:ondrej/php &>/dev/null
apt-get update &>/dev/null
apt-get install php7.1-fpm php7.1-mysql php7.1-mcrypt php7.1-mbstring php7.1-bcmath php7.1-cli php7.1-curl php7.1-soap php7.1-xml php7.1-intl -y &>/dev/null

echo "Configuring Nginx"
cp /var/www/provision/nginx_vhost /etc/nginx/sites-available/nginx_vhost &>/dev/null
ln -s /etc/nginx/sites-available/nginx_vhost /etc/nginx/sites-enabled/
rm -rf /etc/nginx/sites-available/default
service nginx restart &>/dev/null

echo "Install composer"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

cd /var/www/
symfony new project

rm /var/www/project/app/config/parameters.yml
cp /var/www/provision/parameters.yml /var/www/project/app/config/parameters.yml

echo "127.0.0.1 symfony.dev" >> /etc/hosts