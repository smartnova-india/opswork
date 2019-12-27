#
# Cookbook:: opstest
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
Chef::Log.info("Starting Recipe")
Chef::Log.info("******Creating a data directory.******")

data_dir = value_for_platform(
  "centos" => { "default" => "/srv/www/shared" },
  "ubuntu" => { "default" => "/srv/www/data" },
  "default" => "/srv/www/config"
)

directory data_dir do
  mode 0755
  owner 'root'
  group 'root'
  recursive true
  action :create
end
Chef::Log.info("Platform: #{node[:platform]}")
case node[:platform]
when 'centos','redhat','fedora','amazon'
  Chef::Log.info("NON UBUNTU") 	
  Chef::Log.info("NODE: #{node.inspect}")
  Chef::Log.debug("NODE: #{node.inspect}")
when 'debian','ubuntu'		
  Chef::Log.info("NODE1: #{Chef::JSONCompat.to_json_pretty(node.to_hash)}")
  # Chef::Log.debug("NODE2: #{Chef::JSONCompat.to_json_pretty(node.to_hash)}")
  # Chef::Log.info("NODE3: #{node.to_yaml}")
end
Chef::Log.info("=============================")
Chef::Log.info("End Recipe")