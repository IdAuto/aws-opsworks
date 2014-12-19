#
# Cookbook Name:: j-wordpress
# Recipe:: capistrano
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

gem_package "capistrano" do
  action :install
  options("--user-install)
end