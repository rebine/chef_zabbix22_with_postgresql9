chef_zabbix22_with_postgresql9
==============================

Chef solo recipe Zabbix 2.2 and PostgreSQL9.3

#DESCRIPTION
============
This cookbook contains Zabbix2.2 server and Postgresql9.3.
And It isnot contains Zabbix Agent.

It tested on Sakura Internet VPS.(CentOS6.5)
I test with Other Chef cookbooks (httpd..iptables..sshd..and user add).

#RECIPE
=======
Recipe: postgresql9::default 
  * script[postgresql repo install] action run (skipped due to not_if)
  * package[postgresql93] action install (up to date)
  * package[postgresql93-libs] action install (up to date)
  * package[postgresql93-server] action install (up to date)
  * package[postgresql93-contrib] action install (up to date)
  * execute[initdb] action run (skipped due to not_if)
  * service[postgresql-9.3] action enable (up to date)
  * template[postgresql.conf] action create (up to date)
  * template[pg_hba.conf] action create (up to date)
  * link[/var/log/pgsql] action create (up to date)

Recipe: zabbix::default 
  * service[zabbix-server] action enable (up to date)
  * script[zabbix repo install] action run (skipped due to not_if)
  * package[zabbix-server-pgsql] action install (up to date)
  * package[zabbix-web-pgsql] action install (up to date)
  * package[zabbix-web-japanese] action install (up to date)
  * script[create role] action run (skipped due to not_if)
  * script[create database] action run (skipped due to not_if)
  * execute[create_table] action run (skipped due to only_if)
  * execute[insert_image] action run (skipped due to only_if)
  * execute[insert_data] action run (skipped due to only_if)
  * template[set zabbix server config] action create
  * cookbook_file[/etc/httpd/conf.d/zabbix.conf] action create (up to date)
  * template[set zabbix web config] action create (up to date)
