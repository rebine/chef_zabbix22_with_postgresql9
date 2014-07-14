#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2014, REDALARM Company Limited.
#
# All rights reserved - Do Not Redistribute
#
service "zabbix-server" do
    service_name "zabbix-server"
    start_command "/sbin/service zabbix-server start && sleep 1"
    stop_command "/sbin/service zabbix-server stop && sleep 1"
    restart_command "/sbin/service zabbix-server restart && sleep 1"
    reload_command "/sbin/service zabbix-server reload && sleep 1"
  action :enable
end

# repository
script "zabbix repo install" do
  not_if "rpm -qa | grep #{node[:zabbix][:repo_rpm]}"
  command "/bin/rpm -ivh #{node[:zabbix][:repourl]}"
end 

# package
node[:zabbix][:package].each do |package_name|
  package package_name do
    action :install
  end
end

# create role
script "create role" do
  not_if "psql -U #{node[:zabbix][:pgsql_superuser]} -c '\\du' | grep #{node[:zabbix][:base_role]} "
  interpreter "bash"
    code <<-EOH
      psql -U #{node[:zabbix][:pgsql_superuser]} -c "\
        CREATE ROLE #{node[:zabbix][:base_role]}; \
        ALTER ROLE #{node[:zabbix][:base_role]} WITH PASSWORD '#{node[:zabbix][:dbpassword]}' \
        NOSUPERUSER NOINHERIT NOCREATEROLE CREATEDB LOGIN"
    EOH
end 

# create database
script "create database" do
  not_if "psql -U #{node[:zabbix][:pgsql_superuser]} -l | grep #{node[:zabbix][:database]} "
  interpreter "bash"
    code <<-EOH
      psql -U #{node[:zabbix][:pgsql_superuser]} -c "\
        CREATE DATABASE #{node[:zabbix][:database]} WITH TEMPLATE = template0 \
        ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C'"
      psql -U #{node[:zabbix][:pgsql_superuser]} -c "\
        ALTER DATABASE #{node[:zabbix][:database]} OWNER TO #{node[:zabbix][:base_role]}"
    EOH
end

# initial database command
execute "create_table" do
  only_if "psql -U #{node[:zabbix][:pgsql_superuser]} -c '\\d' #{node[:zabbix][:database]} | grep 'No relations found.'"
  command "psql -U #{node[:zabbix][:base_role]} -f #{node[:zabbix][:sql_dir]}/schema.sql #{node[:zabbix][:database]}"
end

execute "insert_image" do
  only_if "psql -U #{node[:zabbix][:pgsql_superuser]} #{node[:zabbix][:database]} -c 'SELECT * FROM images' | grep '(0 rows)'"
  command "psql -U #{node[:zabbix][:base_role]} -f #{node[:zabbix][:sql_dir]}/images.sql #{node[:zabbix][:database]}"
end

execute "insert_data" do
  only_if "psql -U #{node[:zabbix][:pgsql_superuser]} #{node[:zabbix][:database]} -c 'SELECT * FROM hosts' | grep '(0 rows)'"
  command "psql -U #{node[:zabbix][:base_role]} -f #{node[:zabbix][:sql_dir]}/data.sql #{node[:zabbix][:database]}"
end

# zabbix server config
template "set zabbix server config" do
  path "#{node[:zabbix][:server_conf]}"
  source "zabbix_server.conf.erb"
  owner "root"
  group "root"
  mode 0600
  backup false
  notifies :restart, resources(:service => "zabbix-server")
end

# zabbix apache config file
template "add zabbix to apache config" do
  path "#{node[:zabbix][:apache_conf]}"
  source "zabbix.conf.erb"
  owner 'root'
  group 'root'
  mode 0644
  backup false
end

# zabbix web config
template "set zabbix web config" do
  path "#{node[:zabbix][:web_conf]}"
  source "zabbix.conf.php.erb"
  owner 'apache'
  group 'apache'
  mode 0644
  backup false
end
