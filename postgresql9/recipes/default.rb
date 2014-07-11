#
# Cookbook Name:: postgresql91
# Recipe:: default
#
# Copyright 2014, REDALARM Company Limited.
#
# All rights reserved - Do Not Redistribute
#

# yum repository rpm install 
script "postgresql repo install" do
  not_if "rpm -qa | grep -i #{node[:postgresql][:repo_rpm]}"
  command "/bin/rpm -ivh #{node[:postgresql][:repourl]}"
end 

# rpm install
node[:postgresql][:package].each do |package_name|
  package package_name do
    action :install
  end
end

# data dir initialize
execute "initdb" do
  not_if "test -d #{node[:postgresql][:dir]}"
  command "/sbin/service postgresql-#{node[:postgresql][:version]} initdb && sleep 20"
  action :run
end

# service start,restart ,reload
service "postgresql-#{node[:postgresql][:version]}" do
    service_name "postgresql-#{node[:postgresql][:version]}"
    start_command "/sbin/service postgresql-#{node[:postgresql][:version]} start && sleep 5"
    restart_command "/sbin/service postgresql-#{node[:postgresql][:version]} restart && sleep 5"
    reload_command "/sbin/service postgresql-#{node[:postgresql][:version]} reload && sleep 5"
  supports value_for_platform(
    "centos" => { "default" => [ :restart, :reload, :status ] }
  )
  action :enable
end

# postgresql.conf
template "postgresql.conf" do
  path "#{node[:postgresql][:dir]}/postgresql.conf"
  source "postgresql.#{node[:postgresql][:version]}.conf.erb"
  owner node[:postgresql][:user]
  group node[:postgresql][:group]
  mode 0600
  notifies :start, resources(:service => "postgresql-#{node[:postgresql][:version]}"), :immediately
end

# pg_hba.conf
template "pg_hba.conf" do
  path "#{node[:postgresql][:dir]}/pg_hba.conf"
  source "pg_hba.conf.erb"
  owner node[:postgresql][:user]
  group node[:postgresql][:group]
  mode 0600
  notifies :reload, resources(:service => "postgresql-#{node[:postgresql][:version]}"), :immediately
end

# symlink to /var/log
link "/var/log/pgsql" do
  to "/var/lib/pgsql/#{node[:postgresql][:version]}/data/pg_log/"
end
