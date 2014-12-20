#
# Cookbook Name:: idautoapps
# Recipe:: set_hostname
#
# Copyright 2014, Identity Automation, LP
#
# All rights reserved - Do Not Redistribute
#

# Generate random hostname
execute "generate_hostname" do
	command "sudo hostname idauto-aws-`echo $RANDOM`"
	action :run
end

# Set environment variables
execute "set_hostname_var" do
	command "sudo HOSTNAME=`hostname`;export HOSTNAME;"
	action :run
end

# Update hostname permanently
execute "make_hostname_perm" do
	command "sed -i 's|HOSTNAME=localhost.localdomain|HOSTNAME=$HOSTNAME|g' /etc/sysconfig/network"
	action :run
end

