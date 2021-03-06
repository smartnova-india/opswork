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
    Chef::Log.debug("Skipping php::configure application #{application} as it is not an PHP app")
    next
  end

  # write out opsworks.php
  template "#{deploy[:deploy_to]}/shared/config/opsworks.php" do
    cookbook 'php'
    source 'opsworks.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :database => deploy[:database],
      :memcached => deploy[:memcached],
      :layers => search("aws_opsworks_layer"),
      :stack_name => stack[:name]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end
end
