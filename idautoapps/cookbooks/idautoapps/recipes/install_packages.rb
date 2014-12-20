#
# Cookbook Name:: idautoapps
# Recipe:: install_packages
#
# Copyright 2014, Identity Automation, LP
#
# All rights reserved - Do Not Redistribute
#

# Install MySQL client package
package "mysql" do
	action :install
end

# Install telnet client package
package "telnet" do
	action :install
end

# Install network utilities package
package "bind-utils" do
	action :install
end

# Install Perl Compatible Regular Expression package
package "pcre-tools" do
	action :install
end

# Install LDAP client package
package "openldap-clients" do
	action :install
end
