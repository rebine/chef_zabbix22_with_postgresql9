default[:postgresql][:version] = "9.3"
default[:postgresql][:repourl] = "http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm"
default[:postgresql][:repo_rpm] = "pgdg-centos93-9.3-1.noarch"
default[:postgresql][:package] = [ "postgresql93","postgresql93-libs","postgresql93-server","postgresql93-contrib" ]
default[:postgresql][:dir]     = "/var/lib/pgsql/#{node[:postgresql][:version]}/data"
default[:postgresql][:log_dir] = "#{node[:postgresql][:dir]}/log"
default[:postgresql][:user]    = "postgres"
default[:postgresql][:group]   = "postgres"
default[:postgresql][:pid_file] = "/var/run/postgresql-#{node[:postgresql][:version]}.pid"
