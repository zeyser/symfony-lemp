touch /var/www/symfonylemp.log
echo "Updating system"
apt-get update &>>/var/www/symfonylemp.log
apt-get upgrade -y &>>/var/www/symfonylemp.log
apt-get install python-software-properties build-essential -y &>>/var/www/symfonylemp.log
apt-get install curl &>>/var/www/symfonylemp.log

mkdir -p /usr/local/bin
curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
chmod a+x /usr/local/bin/symfony

systemctl stop apache2 &>>/var/www/symfonylemp.log
systemctl disable apache2 &>>/var/www/symfonylemp.log
apt remove apache2 &>>/var/www/symfonylemp.log

echo "Install git"
apt-get install git -y &>>/var/www/symfonylemp.log

echo "Install ru language"
apt-get install language-pack-ru -y &>>/var/www/symfonylemp.log

echo "Install nginx"
apt-get install nginx -y &>>/var/www/symfonylemp.log

echo "Install MariaDB"
apt-get install software-properties-common -y &>>/var/www/symfonylemp.log
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 &>>/var/www/symfonylemp.log
add-apt-repository -y 'deb [arch=amd64,i386] http://mirrors.hustunique.com/mariadb/repo/10.1/ubuntu xenial main' &>>/var/www/symfonylemp.log
apt-get update &>>/var/www/symfonylemp.log

apt-get install mariadb-server-10.0 -y &>>/var/www/symfonylemp.log

echo "Configure MariaDB"
mysql -p -e "CREATE DATABASE symfony; CREATE USER 'symfony'@'%' IDENTIFIED BY 'symfony'; GRANT ALL PRIVILEGES ON symfony.* TO 'symfony'@'%'; GRANT ALL PRIVILEGES ON symfony.* TO 'symfony'@'10.4.4.1'; FLUSH PRIVILEGES;"

echo "Install PHP 7.1"
add-apt-repository -y ppa:ondrej/php &>>/var/www/symfonylemp.log
apt-get update &>>/var/www/symfonylemp.log
apt-get install php7.1-fpm php7.1-mysql php7.1-mcrypt php7.1-mbstring php7.1-bcmath php7.1-cli php7.1-curl php7.1-soap php7.1-xml php7.1-intl -y &>>/var/www/symfonylemp.log

echo "Configuring Nginx"
cp /var/www/provision/nginx_vhost /etc/nginx/sites-available/nginx_vhost &>>/var/www/symfonylemp.log
ln -s /etc/nginx/sites-available/nginx_vhost /etc/nginx/sites-enabled/
rm -rf /etc/nginx/sites-available/default
service nginx restart &>>/var/www/symfonylemp.log

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