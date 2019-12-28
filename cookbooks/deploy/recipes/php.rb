#
# Cookbook Name:: deploy
# Recipe:: php
#

include_recipe 'deploy'
include_recipe "mod_php7_apache2"
include_recipe "mod_php7_apache2::php"

search("aws_opsworks_app").each do |deploy|
  deploy[:application_type]="php"
  deploy[:application]=deploy[:shortname]
  deploy[:deploy_to]="/srv/www/#{deploy[:shortname]}"
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
  # Chef::Log.info("App: #{Chef::JSONCompat.to_json_pretty(deploy.to_hash)}")
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app deploy[:application]
  end
end

