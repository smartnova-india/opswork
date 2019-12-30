
require 'openssl'

root_pw = String.new
while root_pw.length < 20
  root_pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

node.default[:mysql][:server_root_password] = root_pw


node.default[:mysql][:name] = "mysql"
node.default[:mysql][:bin_dir] = "/usr/bin"


debian_pw = String.new
while debian_pw.length < 20
  debian_pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

node.default[:mysql][:debian_sys_maintainer_user]     = 'debian-sys-maint'
node.default[:mysql][:debian_sys_maintainer_password] = debian_pw

node.default[:mysql][:bind_address]         = '0.0.0.0'
node.default[:mysql][:port]                 = 3306


node.default[:mysql][:datadir]              = '/mnt/data/mysql'
node.default[:mysql][:logdir]               = "#{node.default[:mysql][:datadir]}/log"
node.default[:mysql][:basedir]              = '/usr'
node.default[:mysql][:user]                 = 'mysql'
node.default[:mysql][:group]                = 'mysql'
node.default[:mysql][:root_group]           = 'root'
node.default[:mysql][:mysqladmin_bin]       = "#{node[:mysql][:bin_dir]}/mysqladmin"
node.default[:mysql][:mysql_bin]            = "#{node[:mysql][:bin_dir]}/mysql"

set[:mysql][:conf_dir]                 = '/etc/mysql'
set[:mysql][:confd_dir]                = '/etc/mysql/conf.d'
set[:mysql][:socket]                   = "#{node.default[:mysql][:datadir]}/tmp/mysqld.sock"
set[:mysql][:pid_file]                 = "#{node.default[:mysql][:datadir]}/tmp/mysqld.pid"
set[:mysql][:grants_path]              = '/etc/mysql/grants.sql'


# if infrastructure_class?('ec2')
#   node.default[:mysql][:ec2_path]                 = '/mnt/mysql'
#   node.default[:mysql][:opsworks_autofs_map_file] = '/etc/auto.opsworks'
#   node.default[:mysql][:autofs_options] = "-fstype=none,bind,rw"
#   node.default[:mysql][:autofs_entry] = "#{node[:mysql][:datadir]} #{node[:mysql][:autofs_options]} :#{node[:mysql][:ec2_path]}"
# end

# Tunables

# InnoDB
node.default[:mysql][:tunable][:innodb_buffer_pool_size]         = '1200M'
node.default[:mysql][:tunable][:innodb_additional_mem_pool_size] = '20M'
node.default[:mysql][:tunable][:innodb_flush_log_at_trx_commit]  = '2'
node.default[:mysql][:tunable][:innodb_lock_wait_timeout]        = '50'

# query cache
node.default[:mysql][:tunable][:query_cache_type]    = '1'
node.default[:mysql][:tunable][:query_cache_size]    = '128M'
node.default[:mysql][:tunable][:query_cache_limit]   = '2M'

# MyISAM & general
node.default[:mysql][:tunable][:max_allowed_packet]  = '32M'
node.default[:mysql][:tunable][:thread_stack]        = '192K'
node.default[:mysql][:tunable][:thread_cache_size]   = '8'
node.default[:mysql][:tunable][:key_buffer]          = '250M'
node.default[:mysql][:tunable][:max_connections]     = '2048'
node.default[:mysql][:tunable][:wait_timeout]        = '180'
node.default[:mysql][:tunable][:net_read_timeout]    = '30'
node.default[:mysql][:tunable][:net_write_timeout]   = '30'
node.default[:mysql][:tunable][:back_log]            = '128'
node.default[:mysql][:tunable][:table_cache]         = '2048'
node.default[:mysql][:tunable][:max_heap_table_size] = '32M'

node.default[:mysql][:tunable][:log_slow_queries]    = File.join(node[:mysql][:logdir], 'mysql-slow.log')
node.default[:mysql][:tunable][:long_query_time]     = 1

node.default[:mysql][:clients] = []

# include_attribute "mysql::customize"
