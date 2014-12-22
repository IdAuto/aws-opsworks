#
# Cookbook Name:: j-wordpress
# Recipe:: default
#
# Copyright 2014, gitwww
#
# All rights reserved - Do Not Redistribute
#
git "/var/www/html" do
  repository "git://github.com:IdAuto/wordpresswww.git"
  revision "master"
  action :sync
end

execute "bundle install" do
	cwd "/var/www/html"
	command "bundle install"
	action :nothing
end


execute "composer install" do
	cwd "/var/www/html"
	command "composer install"
	action :nothing
end

execute "npm install" do
	cwd "/var/www/html/web/app/themes/themia"
	command "npm install"
	notifies :restart, "service[httpd]", :immediately
end