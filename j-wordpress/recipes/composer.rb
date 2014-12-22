#
# Cookbook Name:: j-wordpress
# Recipe:: composer
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "composer" do
  cwd "/var/www/html"
  code <<-EOH
  curl -sS https://getcomposer.org/installer | php
  EOH
end