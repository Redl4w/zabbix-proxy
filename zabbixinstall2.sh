#!/bin/bash

#------------------Script Para instalação do zabbix proxy --------------------------#
#---------------------------Iland Soluções------------------------------------------#
#-------------Data:04/04/2016---------Paulo Arthur----------------------------------#


yum update -y

echo "Iniciando a instalação do zabbix proxy"
sudo yum -y install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
sudo yum install postgresql10{,-server,-libs} -y
sudo /usr/pgsql-10/bin/postgresql-10-setup initdb
#até aqui ok
cd /paulo
rm -r /var/lib/pgsql/10/data/pg_hba.conf
cd /paulo
cp /paulo/pg_hba.conf /var/lib/pgsql/10/data/

echo "editando configurações do postgresql.conf"

#rm -r /var/lib/pgsql/10/data/postgresql.conf
echo"cp /home/zabbix/postgresql.conf  /var/lib/pgsql/10/data/postgresql.conf"

echo "Habilitando e iniciando o serviço do postgresql"

sudo systemctl enable postgresql-10
sudo systemctl start postgresql-10

echo " Instalando o zabbix proxy"
sudo rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
sudo yum install zabbix-{agent,proxy-pgsql} -y

echo " Criando o db e importando o schema"

#useradd  zabbix -s /bin/false
#su - postgres
#psql

sudo psql -U postgres -c "CREATE ROLE zabbix LOGIN PASSWORD 'Senha@123-ila';"
sudo psql -U postgres -c "CREATE DATABASE zabbix_proxy OWNER zabbix;"
#\q
#quit

zcat /usr/share/doc/zabbix-proxy-pgsql-3.4.15/schema.sql.gz | psql -U zabbix zabbix_proxy

#echo " Editar zabbix proxy.conf"
#rm -r /etc/zabbix/zabbix-proxy.conf
#cp /paulo/zabbix/zabbix.proxy.conf /etc/zabbix/zabbix-proxy.conf"


echo "FIMMMMM"
#-------------GRACAS A DEUS -----------#


