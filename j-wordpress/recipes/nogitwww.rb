#
# Cookbook Name:: j-wordpress
# Recipe:: nogitwww
# Copyright 2014, gitwww
#
# All rights reserved - Do Not Redistribute
#
cookbook_file "wordpresswww-master.tar" do
	path "/var/www/html/wordpresswww-master.tar"
	action :create
end

execute "tar" do
	cwd "/var/www/html"
	command "tar xvf wordpresswww-master.tar"
end

execute "bundle install" do
	cwd "/var/www/html"
	command "bundle install"
end

execute "composer install" do
	user "root"
	cwd "/var/www/html"
	command "./composer.phar install"
end

execute "npm install" do
	cwd "/var/www/html/web/app/themes/themia"
	command "npm install"
	notifies :restart, "service[httpd]", :immediately
end