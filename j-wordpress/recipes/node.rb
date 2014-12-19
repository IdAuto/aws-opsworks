#
# Cookbook Name:: j-wordpress
# Recipe:: node
#
# Copyright 2014, IDENTITY AUTOMATION
#
# All rights reserved - Do Not Redistribute
#

package "nodejs" do
	action :install
end

package "npm" do
	action :install
end