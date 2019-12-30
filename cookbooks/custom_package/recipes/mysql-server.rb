include_attributes "mysql-server"
Chef::Log.info("Setting up mysql server with data directory:#{node[:mysql][:datadir]}")
['tmp','log'].each do |dir|
  directory "#{node[:mysql][:datadir]}/#{dir}" do
    owner node[:mysql][:user]
    group node[:mysql][:group]
    action :create
  end
end
mysql_service 'default' do
  version '5.7'
  bind_address node[:mysql][:bind_address]
  port node[:mysql][:port]
  data_dir node[:mysql][:datadir]
  initial_root_password node[:mysql][:server_root_password]
  action [:create, :start]
end

template 'mysql configuration' do
  path value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => '/etc/my.cnf'},
    'default' => '/etc/mysql/my.cnf'
    )
  source 'my.cnf.erb'
  backup false
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, "mysql_service[default]"
end
