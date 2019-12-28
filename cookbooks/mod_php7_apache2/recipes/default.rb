include_recipe 'apache2'

bash "adding apt-repository" do
code <<-EOH
apt -y install python-software-properties
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php
apt-get update
EOH
end
Chef::Log.info("Ready for aws_opsworks_app") 
Chef::Log.info("=======================START1=========================") 

search("aws_opsworks_app").each do |app|
  Chef::Log.info("********** The app's short name is '#{app['shortname']}' **********")
  Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")
end

node[:mod_php7_apache2][:packages].each do |pkg|
  package pkg do
    action :install
    ignore_failure(pkg.to_s.match(/^php-pear-/) ? true : false) # some pear packages come from EPEL which is not always available
    retries 3
    retry_delay 5
  end
end
Chef::Log.info("======================END1==========================") 
Chef::Log.info("Process each apps") 
Chef::Log.info("=======================START2=========================") 
# node[:deploy].each do |application, deploy|
search("aws_opsworks_app").each do |deploy|
  # deploy[:shortname]
  
  deploy[:application_type]="php"
  application=deploy[:application]=deploy[:shortname]
  deploy[:group]='www-data'
  deploy[:user]='deploy'
  deploy[:home]='/home/deploy'
  deploy[:shell]='/bin/bash'
  deploy[:deploy_to]="/srv/www/#{deploy[:shortname]}" 
  Chef::Log.info("Running deploy::php application #{application}") 
  if deploy[:application_type] != 'php'
    Chef::Log.info("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end
  # next if node[:deploy][application][:database].nil?

  bash "Enable network database access for httpd" do
    boolean = "httpd_can_network_connect_db"
    user "root"
    code <<-EOH
      semanage boolean --modify #{boolean} --on
    EOH
    not_if { OpsWorks::ShellOut.shellout("/usr/sbin/getsebool #{boolean}") =~ /#{boolean}\s+-->\s+on\)/ }
    only_if { platform_family?("rhel") && ::File.exist?("/usr/sbin/getenforce") && OpsWorks::ShellOut.shellout("/usr/sbin/getenforce").strip == "Enforcing" }
  end

  include_recipe 'mod_php7_apache2::mysql_adapter'
end
Chef::Log.info("======================END2==========================") 
include_recipe 'apache2::mod_php7'
