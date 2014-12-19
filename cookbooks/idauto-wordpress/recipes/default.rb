#
# Cookbook Name:: idauto-wordpress
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"

apache_site "default" do
	enable true
end


