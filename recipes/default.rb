#
# Cookbook Name:: monit
# Recipe:: default
#
# Copyright (C) 2013 Gabor Garami
# 
# All rights reserved - Do Not Redistribute
#

package 'monit' do
  action :install
end

service 'monit' do
  supports :status => true, :restart => true, :reload => true
  reload_command platform?("debian") ? "/usr/sbin/monit reload" : "/usr/bin/monit reload"
  action :enable
end

%w(/etc/monit /var/lib/monit).each do |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode 00755
    action :create
  end
end

default_options = {
  'check_interval' => '120',
  'log'            =>'/var/log/monit.log',
  'mailserver'     => {
    'host'         => 'localhost',
    'port'         => '25', 
  },
  'httpd'          => {
    'enable'       => false,
    'address'      =>'localhost',
    'port'         =>'2812',
    'user'         =>'admin',
    'password'     => 'monit'
  },
  'mailformat'     => {
    'from'         => "root@#{node[:fqdn]}",
    'subject'      => 'monit alert --  $EVENT $SERVICE'
  },
  'mmonit_url' => nil
}

options = node['monit'] || {}
options.delete('mailformat') if options['mailformat'] and options['mailformat'].empty?
options = default_options.merge(options)
options['httpd'] = default_options['httpd'].merge(options['httpd'])
options['mailformat'] = default_options['mailformat'].merge(options['mailformat'])
options['mailserver'] = default_options['mailserver'].merge(options['mailserver'])


cookbook_file '/etc/default/monit' do
  source 'monit.debuntu.confd'
  notifies :restart, 'service[monit]', :delayed
  only_if { platform?('debian', 'ubuntu') }
end

template '/etc/monit/monitrc' do
  source 'monitrc.erb'
  variables(
    :options => options
  )
  notifies :restart, 'service[monit]', :delayed
end

monit_check 'monit' do
  action :enable
end

monit_check 'sshd' do
  if platform?('ubuntu')
    service 'ssh'
    process 'sshd'
    pidfile '/var/run/sshd.pid'
  end

  host 'localhost'
  port '22'
end
