#
# Cookbook Name:: deploy
# Recipe:: php-restart
#

include_recipe "deploy"
include_recipe "apache2::service"

# node[:deploy].each do |application, deploy|
search("aws_opsworks_app").each do |deploy|  
  deploy[:application_type]="php"
  application = deploy[:application]=deploy[:shortname]
  deploy[:deploy_to]="/srv/www/#{deploy[:shortname]}"
  deploy[:group]='www-data'
  deploy[:user]='deploy'
  deploy[:home]='/home/deploy'
  deploy[:shell]='/bin/bash'
  deploy[:deploy_to]="/srv/www/#{deploy[:shortname]}"  
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php-restart application #{application} as it is not a PHP app")
    next
  end
  
  execute "restart Apache" do
    cwd deploy[:current_path]
    command "sleep #{deploy[:sleep_before_restart]} && #{deploy[:restart_command]}"
    action :run
    
    only_if do 
      File.exists?(deploy[:current_path])
    end
    
    notifies :restart, "service[apache2]"
  end
    
end


