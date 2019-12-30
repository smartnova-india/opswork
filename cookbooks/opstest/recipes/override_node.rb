Chef::Log.info("Starting Override Node")
node.default[:deploy]={}
search("aws_opsworks_app").each do |deploy|
  application_name = deploy[:shortname];
  node.default[:deploy]["#{application_name}"]={
  		"application"=> application_name,
  		"application_type"=>"php",
  		"shortname"=> application_name,
  		"deploy_to"=>"/srv/www/#{deploy[:shortname]}",
  		"group"=>"www-data",
  		"user"=>"deploy",
  		"shell"=>"/bin/bash",
  		"home"=>"/home/deploy",
  		"deploy"=>deploy[:deploy],
  		"deploy_to"=>"/srv/www/#{deploy[:shortname]}",
  		"scm"=>{
  			"scm_type"=> deploy[:app_source][:type],
  			"repository"=> deploy[:app_source][:url],
  			"password"=> deploy[:app_source][:password],
  			"revision"=> deploy[:app_source][:revision],
  			"ssh_key"=> deploy[:app_source][:ssh_key],
  			"user"=> deploy[:app_source][:user]
  		},
  		"auto_bundle_on_deploy"=>deploy[:attributes][:auto_bundle_on_deploy],
  		"document_root"=>deploy[:attributes][:document_root]
  }
end 

Chef::Log.info("Ending Override Node")