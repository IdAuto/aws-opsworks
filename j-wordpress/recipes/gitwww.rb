#
# Cookbook Name:: j-wordpress
# Recipe:: gitwww
#
# Copyright 2014, gitwww
#
# All rights reserved - Do Not Redistribute
#
git "/var/www/html" do
  repository "https://github.com/IdAuto/wordpresswww.git"
  revision "master"
  action :checkout
end

execute "bundle install" do
	cwd "/var/www/html"
	command "bundle install"
end

execute "composer install" do
	cwd "/var/www/html"
	command "composer install"
end

execute "npm install" do
	cwd "/var/www/html/web/app/themes/themia"
	command "npm install"
	notifies :restart, "service[httpd]", :immediately
end