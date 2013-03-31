# Author:: Gabor Garami (<hron@hron.me>)
# Cookbook Name:: monit
# Resource:: service
#
# Copyright:: (C) 2013 Gabor Garami
# 
# All rights reserved - Do Not Redistribute

actions :enable, :disable

attribute :file_name, :kind_of => String, :name_attribute => true
attribute :group, :kind_of => String, :default => nil

attribute :process, :kind_of => String, :default => nil
attribute :pidfile, :kind_of => String, :default => nil

attribute :service, :kind_of => String, :default => nil
attribute :start_program, :kind_of => String, :default => nil
attribute :stop_program, :kind_of => String, :default => nil

attribute :host, :kind_of => String, :default => 'localhost'
attribute :port, :kind_of => [Fixnum,String], :default => nil
attribute :ssl, :kind_of => [TrueClass, FalseClass], :default => false
attribute :protocol, :kind_of => String, :default => nil
attribute :template, :kind_of => String, :default => "generic_service"

default_action :enable

def initialize(*args)
  super
end

def process_or_default
  process || file_name
end

def service_or_default
  service || process_or_default
end

def pidfile_or_default
  pidfile || "/var/run/#{service_or_default}.pid"
end

def start_or_default
  start_program || if platform?('redhat', 'centos', 'fedora', 'suse', 'amazon', 'scientific')
                     "/sbin/service #{service_or_default} start"
                   elsif platform?('ubuntu')
                     "/usr/sbin/service #{service_or_default} start"
                   elsif platform?('debian', 'gentoo')
                     "/etc/init.d/#{service_or_default} start"
                   end
end

def stop_or_default
  stop_program || if platform?('redhat', 'centos', 'fedora', 'suse', 'amazon', 'scientific')
                     "/sbin/service #{service_or_default} stop"
                   elsif platform?('ubuntu')
                     "/usr/sbin/service #{service_or_default} stop"
                   elsif platform?('debian', 'gentoo')
                     "/etc/init.d/#{service_or_default} stop"
                   end
end
