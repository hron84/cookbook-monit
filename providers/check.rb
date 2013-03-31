# Author:: Gabor Garami (<hron@hron.me>)
# Cookbook Name:: monit
# Provider:: service
#
# Copyright:: (C) 2013 Gabor Garami
# 
# Released under the MIT license

include Chef::Mixin::ShellOut

action :enable do
  template "/etc/monit/conf.d/#{new_resource.file_name}" do
    source "#{new_resource.template}.erb"
    variables ({:options => new_resource})
    notifies :reload, 'service[monit]', :delayed
  end
  new_resource.updated_by_last_action(true)
end

action :disable do
  file "/etc/monit/conf.d/#{new_resource.file_name}" do
    action :delete
    notifies :reload, 'service[monit]', :delayed
  end
  new_resource.updated_by_last_action(true)
end
