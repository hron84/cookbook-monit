#
# Cookbook Name:: monit
# Recipe:: mmonit
#
# Copyright:: (C) 2013 Gabor Garami
# 
# All rights reserved - Do Not Redistribute
#

mmonit_pkg = "#{Chef::Config[:file_cache_path]}/mmonit.tar.gz"

arch = node[:kernel][:machine] == 'x86_64' ? 'x64' : 'x86'
pkg_platform = if platform?('freebsd')
                 "freebsd#{node[:kernel][:release][0]}-#{arch}"
               elsif node[:kernel][:name] == 'Linux'
                 "linux-#{arch}"
               elsif platform?("darwin")
                 "macosx-universal"
               elsif platform?("openbsd")
                 "openbsd-#{arch}"
               elsif platform?("solaris")
                 "solaris-x86" # TODO we currently support x86 platform
               end

mmonit_version = node[:mmonit][:version]


checksums = {
  "freebsd6-x64" => "533d41e470284539e74113483220bc2c531c6cdf434dd00f07141adc5e27b9db",
  "freebsd6-x86" => "db65d8bb5e0f356874381ece23de4969e95b2202b8e79e97d625a644c4d0f25f",
  "freebsd7-x64" => "cb066760f758dc6dd686b9030362e03677b77965cdf4ef1caa463a24454d9b8f",
  "freebsd7-x86" => "9d1aed86adbfc86acbc00616f08da4af2554df9a1f36ca15fa2f5f8623e5f50f",
  "freebsd8-x64" => "ecac737753932969f495b38c5c77b81af1ac56c97a92d02c239499c0d5106827",
  "freebsd8-x86" => "4d30b10577131f4e13e594cf363ef7c94c639191666f0b5ec340e45e0d2f4d33",
  "linux-x64"    => "53af1a7da9538023e9b731d6f302a17aa984a68b16e53596cf53ba15f3fe1586",
  "linux-x86"    => "174baaf41da23985c5f9e234dc6501f5d903ff872247e33f6a0a2834d95dd695",
  "macosx-universal" => "b531a328f0ec13a61c094fab64cf6868301be0ed07cd44bbb682f7e92f058c9f",
  "openbsd-x64"  => "a0a2f7f092332aa55184d46c85c08b5fbf52f6fc4aa74b552e2749f387b0b0b6",
  "openbsd-x86"  => "a1d71ab5c163680d8ec0d4d33b83a4528f8d37606ee5bb7bb9ee2f2bd6601860",
  "solaris-x86"  => "9cbd38f858baa4f8b3ffe9f790b674485a1be2f59818592c60c841ad577be4fa",
}


pkg_name = "mmonit-#{mmonit_version}-#{pkg_platform}"

remote_file mmonit_pkg do
  source "http://mmonit.com/dist/#{pkg_name}.tar.gz"
  checksum node[:mmonit][:checksum] || checksums[pkg_platform]
  action :create_if_missing
  notifies :run, 'execute[extract mmonit package]', :immediately
end

execute 'extract mmonit package' do
  command "tar zxf #{mmonit_pkg}"
  cwd "/opt"
  creates "/opt/mmonit-#{mmonit_version}"

  action :nothing
end

service "mmonit" do
  pattern "mmonit"
  start_command "/opt/mmonit-#{mmonit_version}/bin/mmonit start"
  stop_command "/opt/mmonit-#{mmonit_version}/bin/mmonit stop"
  supports :status => false, :restart => false, :reload => false
  action :start
end

monit_check "mmonit" do
  start_program "/opt/mmonit-#{mmonit_version}/bin/mmonit start"
  stop_program "/opt/mmonit-#{mmonit_version}/bin/mmonit stop"
  process "mmonit"
  pidfile "/opt/mmonit-#{mmonit_version}/logs/mmonit.pid"
  port 8080
  protocol 'http'
end

# vim: ft=chef
