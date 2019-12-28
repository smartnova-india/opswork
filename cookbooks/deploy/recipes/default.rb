include_recipe 'dependencies'
# node[:deploy].each do |application, deploy|
# 
# default[:opsworks][:deploy_user][:shell] = '/bin/bash'
# default[:opsworks][:deploy_user][:user] = 'deploy'
# default[:opsworks][:deploy_user][:home] = '/home/deploy'
# default[:opsworks][:deploy_user][:group] = 'www-data'


search("aws_opsworks_app").each do |deploy|
  deploy[:application_type]="php"
  deploy[:application]=deploy[:shortname]
  deploy[:group]='www-data'
  deploy[:user]='deploy'
  deploy[:home]='/home/deploy'
  deploy[:shell]='/bin/bash'
  deploy[:deploy_to]="/srv/www/#{deploy[:shortname]}"
  deploy[:scm]=deploy[:app_source]
  deploy[:scm][:scm_type]=deploy[:app_source][:type]
  deploy[:scm][:repository]=deploy[:app_source][:url]
  deploy[:auto_bundle_on_deploy]=deploy[:attributes][:auto_bundle_on_deploy]
  deploy[:document_root]=deploy[:attributes][:document_root]
  opsworks_deploy_user do
    deploy_data deploy
  end
end
