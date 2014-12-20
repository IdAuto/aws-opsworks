#
# Cookbook Name:: idautoapps
# Recipe:: manage_directories
#
# Copyright 2014, Identity Automation, LP
#
# All rights reserved - Do Not Redistribute
#

directory "/var/opt/idauto/backup" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

directory "/var/opt/idauto/i18n" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

directory "/var/opt/idauto/common/lib" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

directory "/var/opt/idauto/logs" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

directory "/var/opt/idauto/logs/audit" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

directory "/var/opt/idauto/menu" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

directory "/var/opt/idauto/certs" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

directory "/var/opt/idauto/tomcat" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

directory "/var/opt/idauto/webapps" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

directory "/var/opt/idauto/backup" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

directory "/var/opt/idauto/common/logstash" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end
