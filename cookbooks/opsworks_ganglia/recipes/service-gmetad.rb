service 'gmetad' do
  provider value_for_platform(
    'ubuntu' => {
      '18.04' => Chef::Provider::Service::Upstart
    }
  )
  supports :status => false, :restart => true
  action :nothing
end
