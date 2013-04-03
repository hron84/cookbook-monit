#
# Cookbook Name:: monit
# Recipe:: default
#
# Copyright (C) 2013 Gabor Garami
# 
# Released under the MIT license
#

package 'monit' do
  action :install
end

service 'monit' do
  supports :status => true, :restart => true, :reload => true
  reload_command platform?("debian") ? "/usr/sbin/monit reload" : "/usr/bin/monit reload"
  action [ :enable, :start ]
end

%w(/etc/monit /etc/monit/conf.d /var/lib/monit).each do |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode 00755
    action :create
  end
end


cookbook_file '/etc/default/monit' do
  source 'monit.debuntu.confd'
  notifies :restart, 'service[monit]', :delayed
  only_if { platform?('debian', 'ubuntu') }
end

template '/etc/monit/monitrc' do
  source 'monitrc.erb'
  variables(
    :options => node[:monit]
  )
  notifies :restart, 'service[monit]', :delayed
end

monit_check 'monit' do
  action :enable
end

