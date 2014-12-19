#
# Cookbook Name:: j-wordpress
# Recipe:: php
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "php" do
  action :install
  notifies :restart, "service[httpd]", :immediately
end

cookbook_file "/var/www/html/info.php" do
 	source "info.php"
 	mode "0644"
 end