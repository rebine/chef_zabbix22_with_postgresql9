zabbix Cookbook
===============
This cookbook install 'Zabbix Official Repository' to yum.repo.d.
And it install zabbix-server and zabbix-postgresql packages.
Notice. it install 'zabbix-web-japanese' rpm.(for graph font ...)

If it will run ,It output this below.
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
  * template[set zabbix server config] action create (up to date)
  * template[add zabbix to apache config] action create (up to date)
  * template[set zabbix web config] action create (up to date)


Requirements
------------
#### OS
  * CentOS6.5

#### packages
  * epel pacages


Attributes
----------
#### zabbix::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['zabbix']['version']</tt></td>
    <td>Strings</td>
    <td>Zabbix version number</td>
    <td><tt>2.2</tt></td>
  </tr>
  <tr>
    <td><tt>['zabbix']['repourl']</tt></td>
    <td>Strings</td>
    <td>Zabbix Official Repository download URL</td>
    <td><tt>http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm</tt></td>
  </tr>
  <tr>
    <td><tt>['zabbix']['repo_rpm']</tt></td>
    <td>Strings</td>
    <td>Repository RPM name it installed.</td>
    <td><tt>zabbix-release-2.2-1.el6.noarch</tt></td>
  </tr>
  <tr>
    <td><tt>['zabbix']['package']</tt></td>
    <td>Strings</td>
    <td>Basic package</td>
    <td><tt>"zabbix-server-pgsql","zabbix-web-pgsql","zabbix-web-japanese"</tt></td>
  </tr>
  <tr>
    <td><tt>['zabbix']['sql_dir']</tt></td>
    <td>Strings</td>
    <td>Directory created by RPM with initial SQLs</td>
    <td><tt>"/usr/share/doc/zabbix-server-pgsql-2.2.4/create"</tt></td>
  </tr>
  <tr>
    <td><tt>['zabbix']['pgsql_superuser']</tt></td>
    <td>Strings</td>
    <td>Postgresql super user</td>
    <td><tt>postgres</tt></td>
  </tr>
  <tr>
    <td><tt>['zabbix']['pgsql_superuser_password']</tt></td>
    <td>Strings</td>
    <td>Password postgresql super user used **MUST CHANGE** </td>
    <td><tt>postgrespassword</tt></td>
  </tr>
  <tr>
    <td><tt>['zabbix']['server_conf']</tt></td>
    <td>Strings</td>
    <td>Zabbix Server config path</td>
    <td><tt>/etc/zabbix/zabbix_server.conf</tt></td>
  </tr>
  <tr>
    <td><tt>['zabbix']['apache_conf']</tt></td>
    <td>Strings</td>
    <td>Apache Server only zabbix config path</td>
    <td><tt>/etc/httpd/conf.d/zabbix.conf</tt></td>
  </tr>
  <tr>
    <td><tt>['zabbix']['timezone']</tt></td>
    <td>Strings</td>
    <td>PHP value timezone</td>
    <td><tt>Asia/Tokyo</tt></td>
  </tr>
  <tr>
    <td><tt>['zabbix']['web_conf']</tt></td>
    <td>Strings</td>
    <td>Setting filepath with Zabbix WEB console</td>
    <td><tt>/etc/zabbix/web/zabbix.conf.php</tt></td>
  </tr>
  <tr>
    <td><tt>['zabbix']['system_name']</tt></td>
    <td>Strings</td>
    <td>Zabbix system name.**MUST CHANGE**</td>
    <td><tt>My Zabbix system</tt></td>
  </tr>
</table>

Usage
-----
#### zabbix::default

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[zabbix]"
  ]
}
```

License and Authors
-------------------
Authors: rebine@redalarm.jp
