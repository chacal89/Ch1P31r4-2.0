#!/bin/bash
echo limpando possiveis instalações
rm -rf /usr/src/ast*
rm -rf /usr/src/dongle*
rm -rf /usr/src/chan*
read year

clear

echo Atualizando repositorios
read year
apt-get update
apt-get upgrade

echo Instalando dependencias
read year
apt-get install wget -y
apt-get install mlocate -y
apt-get install vim -y
apt-get install php5 -y
apt-get install apache2 -y
apt-get install mysql-server -y
apt-get install mysql-client -y
apt-get install gcc -y
apt-get install g++ -y
apt-get install ncurses-dev -y
apt-get install libxml2 -y
apt-get install libxml2-dev -y
apt-get install linux-headers-`uname -r` -y
apt-get install openssl -y
apt-get install openssh-server -y
apt-get install openssh-client -y
apt-get install libnewt-dev -y
apt-get install zlib1g -y
apt-get install zlib1g-dev -y
apt-get install unixodbc -y
apt-get install unixodbc-dev -y
apt-get install libtool -y
apt-get install make -y
apt-get install tar -y
apt-get install wget -y
apt-get install build-essential -y
apt-get install php5-sqlite -y
apt-get install pkg-config -y
apt-get install libsqlite3-dev -y
apt-get install sqlite -y
apt-get install sqlite3 -y
apt-get install vlibjansson-dev -y
apt-get install uuid-dev -y
apt-get install libssl-dev -y
apt-get install libncurses5-dev -y
apt-get install libreadline-dev -y
apt-get install libreadline6-dev -y
apt-get install libxml2-dev -y
apt-get install libmysqlclient-dev -y
apt-get install libcurl4-openssl-dev -y
apt-get install libjansson-dev -y
apt-get install automake -y
apt-get install htop -y
apt-get install sudo
apt-get install unzip -y
apt-get install tcpdump -y

echo Dando Permissão Sudoers para programmer
read year
echo "programmer ALL=(ALL:ALL) ALL" >> /etc/sudoers

echo Baixando Asterisk e descompactando
read year
cd /usr/src/
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13.18.2.tar.gz
tar -vzxf asterisk-13.18.2.tar.gz
cd /usr/src/asterisk-13.18.2/

echo Compilando asterisk
read year
./configure

echo Selecionar CDR do mysql
read year
make menuselect

echo Ainda Compilando asterisk
read year
make && make install && make config && make samples
echo ########### ATÉ AQUI OK

echo Baixando DAHDI e descompactando
read year
cd /usr/src
wget https://github.com/chacal89/Ch1P31r4-2.0/raw/master/dahdi-linux-complete-2.10.1%2B2.10.1.tar.gz
tar -vzxf dahdi-linux-complete-2.10.1+2.10.1.tar.gz
cd /usr/src/dahdi-linux-complete-2.10.1+2.10.1/

echo Compilando DAHDI
read year
make && make install && make config
echo ########## MAIS UMA ETAPA CONCLUIDA

echo Baixando Chan_Dongle e descompactando
read year
cd /usr/src
wget https://github.com/chacal89/Ch1P31r4-2.0/raw/master/master.zip
unzip master.zip
cd /usr/src/asterisk-chan-dongle-master

echo Compilando Chan_Dongle
read year
./bootstrap

echo Ainda Compilando Chan_Dongle
read year
./configure --with-astversion=13.18.2

echo Ainda Compilando Chan_Dongle
read year
make && make install
echo ### UFA TUDO COMPILADO

echo Iniciando asterisk
read year
/etc/init.d/asterisk start

echo Inicializando Chan_dongle.so
read year
asterisk -rx "module load chan_dongle.so"

echo Download e Descompactar Diretório Asterisk
read year
cd /usr/src
wget https://github.com/chacal89/Ch1P31r4-2.0/raw/master/asterisk.zip
unzip asterisk.zip

echo Substituindo o diretório Asterisk
read year
rm -rf /etc/asterisk
mv asterisk /etc/

echo Download e Descompactar Diretório Agi-bin
read year
cd /usr/src
wget https://github.com/chacal89/Ch1P31r4-2.0/raw/master/agi-bin.zip
unzip agi-bin.zip

echo Substituindo o diretório Agi-bin
read year
rm -rf /var/lib/asterisk/agi-bin
mv agi-bin /var/lib/asterisk/

echo Download e Descompactar Diretório html
read year
cd /usr/src
wget https://github.com/chacal89/Ch1P31r4-2.0/raw/master/html.zip
unzip html.zip

echo Substituindo o diretório html
read year
rm -rf /var/www/html
mv html /var/www/

echo Download e criação do diretório scripts em root
read year
cd /root/
mkdir scripts
cd /root/scripts/
wget https://github.com/chacal89/Ch1P31r4-2.0/raw/master/force_restart_apache
wget https://github.com/chacal89/Ch1P31r4-2.0/raw/master/force_restart_asterisk
wget https://github.com/chacal89/Ch1P31r4-2.0/raw/master/verificamemoria


echo Ajustando Permissões
read year
chown -R www-data:www-data /etc/asterisk
chown -R asterisk. /etc/asterisk
chmod -R www-data:www-data /etc/asterisk/rao*
chown -R www-data:www-data /var/www/html/dongle/*
chown -R www-data:www-data /var/www/html/dongle/css/images
chmod -R www-data:www-data /root/scripts/*
chmod 777 force_restart_asterisk /root/scripts/
chmod 777 force_restart_apache /root/scripts/
chmod 777 verificamemoria /root/scripts/


echo reiniciando asterisk
read year
/etc/init.d/asterisk restart

echo reiniciando apache
read year
/etc/init.d/apache2 restart

echo Adicione as seguintes linhas ao crontab clicando com botao direito
echo "0 */1 * * * sudo /etc/asterisk/verificamodem.php >> /dev/null"
echo "0 */2 * * * sudo /etc/asterisk/limpamodem.php >> /dev/null"
echo ""
echo "0 1 * * * /root/scripts/force_restart_asterisk >> /dev/null"
echo "10 1 * * * /root/scripts/force_restart_apache >> /dev/null"
echo ""
echo "0 2 * * * /root/scripts/verificamemoria >> /dev/null"
echo ""
echo ""
echo "*/1 * * * * sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * * sleep 5 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * * sleep 10 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * * sleep 15 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * * sleep 20 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * * sleep 25 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * * sleep 30 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * * sleep 35 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * * sleep 40 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * * sleep 45 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * * sleep 50 && sudo /etc/asterisk/monitorasterisk.php"
echo "*/1 * * * * sleep 55 && sudo /etc/asterisk/monitorasterisk.php"
read year
echo Vamos la colar agora
read year
crontab -e

echo Editando Visudo
read year
echo Copiar e Colar abaixo de Users Privilleges abaixo de root
echo "programmer ALL=(ALL:ALL) ALL NOPASSWD:ALL"
echo "www-data ALL=(ALL:ALL) ALL NOPASSWD:ALL"
read year
echo Vamos La
read year
visudo

echo Zerando dongle.db para cadastro dos modulos
echo copiar com o botao direito e colar no sqlite, depois .quit pra sair
read year
echo Vamos la
read year
cd /var/www/html/dongle/
sqlite3 dongle.db

echo FIM AGORA CTRL+C para cancelar reboot ou enter para reboot
read year
reboot
