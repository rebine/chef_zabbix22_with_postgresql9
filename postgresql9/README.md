postgresql Cookbook
===============
This cookbook install 'PostgreSQL 9.3 Repository' to yum.repo.d.
And it install PostgreSQL packages.
Notice. it tested on 1024MB VPS server. 

If it will run ,It output this below.
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

Requirements
------------
#### OS
  * CentOS6.5

#### packages
  * epel pacages


Attributes
----------
#### postgresql::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['postgresql']['version']</tt></td>
    <td>Strings</td>
    <td>PostgreSQL version number</td>
    <td><tt>9.3</tt></td>
  </tr>
  <tr>
    <td><tt>['postgresql']['repourl']</tt></td>
    <td>Strings</td>
    <td>PostgreSQL Official Repository download URL</td>
    <td><tt>http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm</tt></td>
  </tr>
  <tr>
    <td><tt>['postgresql']['repo_rpm']</tt></td>
    <td>Strings</td>
    <td>Repository RPM name it installed.</td>
    <td><tt>pgdg-centos93-9.3-1.noarch</tt></td>
  </tr>
  <tr>
    <td><tt>['postgresql']['package']</tt></td>
    <td>Arrays</td>
    <td>Basic package</td>
    <td><tt>"postgresql93","postgresql93-libs","postgresql93-server","postgresql93-contrib"</tt></td>
  </tr>
  <tr>
    <td><tt>['postgresql']['dir']</tt></td>
    <td>Strings</td>
    <td>Directory created by RPM with initial command</td>
    <td><tt>"/var/lib/pgsql/#{node[:postgresql][:version]}/data"</tt></td>
  </tr>
  <tr>
    <td><tt>['postgresql']['log_dir']</tt></td>
    <td>Strings</td>
    <td>Default log directory</td>
    <td><tt>#{node[:postgresql][:dir]}/log</tt></td>
  </tr>
  <tr>
    <td><tt>['postgresql']['user']</tt></td>
    <td>Strings</td>
    <td>PostgreSQL super user userid</td>
    <td><tt>postgres</tt></td>
  </tr>
  <tr>
    <td><tt>['postgresql']['group']</tt></td>
    <td>Strings</td>
    <td>PostgreSQL super user groupid</td>
    <td><tt>postgres</tt></td>
  </tr>
  <tr>
    <td><tt>['postgresql']['pid_file']</tt></td>
    <td>Strings</td>
    <td>PostgreSQL pid file path</td>
    <td><tt>/var/run/postgresql-#{node[:postgresql][:version]}.pid</tt></td>
  </tr>
</table>

Usage
-----
#### postgresql::default

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[postgresql]"
  ]
}
```

License and Authors
-------------------
Authors: rebine@redalarm.jp
