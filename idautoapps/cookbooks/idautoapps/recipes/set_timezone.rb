#
# Cookbook Name:: idautoapps
# Recipe:: set_timezone
#
# Copyright 2014, Identity Automation, LP
#
# All rights reserved - Do Not Redistribute
#

timezone = "America/Chicago"

link "/etc/localtime" do
	to "/usr/share/zoneinfo/#{timezone}"
	not_if "readlink /etc/localtime | grep -q '#{timezone}$'"
end