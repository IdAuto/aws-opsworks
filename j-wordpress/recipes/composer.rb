#
# Cookbook Name:: j-wordpress
# Recipe:: php
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "install_something" do
  user "root"
  cwd "/var/www/html"
  code <<-EOH
  curl -sS https://getcomposer.org/installer | php
  EOH
end