#
# Cookbook Name:: deploy
# Recipe:: web-restart

include_recipe 'deploy'

search("aws_opsworks_app").each do |deploy|  
  deploy[:application_type]="php"
  application = deploy[:application]=deploy[:shortname]
  deploy[:deploy_to]="/srv/www/#{deploy[:shortname]}"
  deploy[:group]='www-data'
  deploy[:user]='deploy'
  deploy[:home]='/home/deploy'
  deploy[:shell]='/bin/bash'
  deploy[:deploy_to]="/srv/www/#{deploy[:shortname]}"
  if deploy[:application_type] != 'static'
    Chef::Log.debug("Skipping deploy::web-restart application #{application} as it is not a static HTML app")
    next
  end

  service 'nginx' do
    supports :status => true, :restart => true, :reload => true
    action :restart
  end
end
