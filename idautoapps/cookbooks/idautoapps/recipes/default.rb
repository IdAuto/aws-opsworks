#
# Cookbook Name:: idautoapps
# Recipe:: install_packages
#
# Copyright 2014, Identity Automation, LP
#
# All rights reserved - Do Not Redistribute
#

###########################################################################
# Perform OS Updates                                                      #
###########################################################################
execute "yum-update" do
	command "sudo yum -y update"
	action :run
end

###########################################################################
# Install packages                                                        #
###########################################################################
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


###########################################################################
# Set timezone                                                            #
###########################################################################
timezone = "America/Chicago"

link "/etc/localtime" do
	to "/usr/share/zoneinfo/#{timezone}"
	not_if "readlink /etc/localtime | grep -q '#{timezone}$'"
end

###########################################################################
# Set hostname                                                            #
###########################################################################
#include_recipe "idautoapps::set_hostname"
# This is currently causing issues.  If you change the hostname then you break the node link.

###########################################################################
# Modify sudoers                                                          #
###########################################################################
execute "sudoers-update" do
	command "sudo sed -i 's|Defaults    requiretty|#Defaults    requiretty|g' /etc/sudoers"
	creates "/tmp/sudoers-update.done"
	not_if { ::File.exists?("/tmp/sudoers-update.done")}
	action :run
end

###########################################################################
# Manage users                                                            #
###########################################################################
user "config" do
	action :create
	comment "IdAuto Appliance configuration account"
	shell "/bin/false"
	password "$6$9wQiDrR3$hreGbkwNaPBqLPP2n/HbEeKMNlxt/Bq9.WQcTe7mvZh9LX0orrJ8TQixYqt.M9eEaqH5N.xSDJliLaC1ownii0"
end

user "tomcat" do
	action :create
	comment "Tomcat system user"
	password "$6$NAsj56eO$rqhXtqlzGaHmj9qAJQgUH8HImdXc0TDGiOptdBr9T1OV1NyC3oDPBMiVorAxVxAhRKNFV6gbIgl7eLEqdyFYm0"
end

###########################################################################
# Manage directories                                                      #
###########################################################################
directory "/var/opt/idauto" do
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

directory "/var/opt/idauto/licenses" do
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

directory "/var/opt/idauto/common" do
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

directory "/var/opt/idauto/common/logstash" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end


###########################################################################
# Modify SSH                                                              #
###########################################################################
execute "sudoers-permitrootlogin" do
	command "sudo sed -i 's|^PermitRootLogin forced-commands-only|\\#PermitRootLogin forced-commands-only|g' /etc/ssh/sshd_config"
	creates "/tmp/sudoers-permitrootlogin.done"
	not_if { ::File.exists?("/tmp/sudoers-permitrootlogin.done")}
	action :run
end

execute "sudoers-maxauthtries" do
	command "sudo sed -i 's|^#MaxAuthTries 6|\\MaxAuthTries 30|g' /etc/ssh/sshd_config"
	creates "/tmp/sudoers-maxauthtries.done"
	not_if { ::File.exists?("/tmp/sudoers-maxauthtries.done")}
	action :run
end

directory "/root/.ssh" do
	action :create
end

execute "copy_authorized_keys" do
	command "sudo cp ~ec2-user/.ssh/authorized_keys /root/.ssh/"
	creates "/tmp/copy_authorized_keys.done"
	not_if { ::File.exists?("/tmp/copy_authorized_keys.done")}
	action :run
end

service "sshd" do
	action :reload
end

###########################################################################
# Install Additional Packages                                             #
###########################################################################
# Install WinEXE
execute "install_winexe" do
	command "sudo rpm -qa | grep -qw winexe || rpm -ivh https://s3.amazonaws.com/idauto-apps/winexe-1.00-2.2.x86_64.rpm"
	creates "/tmp/install_winexe.done"
	not_if { ::File.exists?("/tmp/install_winexe.done")}
	action :run
end

# Install Java
execute "install_java" do
	command "sudo rpm -qa | grep -qw jre || rpm -ivh https://s3.amazonaws.com/idauto-apps/jre-7u71-linux-x64.rpm"
	creates "/tmp/install_java.done"
	not_if { ::File.exists?("/tmp/install_java.done")}
	action :run
end

execute "enable_java" do
	command "sudo /usr/sbin/alternatives --install /usr/bin/java java /usr/java/latest/bin/java 20000"
	creates "/tmp/enable_java.done"
	not_if { ::File.exists?("/tmp/enable_java.done")}
	action :run
end

# Install MySQL Connector
mysql_connector_major = "5.1"
mysql_connector_minor = "33"
remote_file "/root/mysql-connector-java-#{mysql_connector_major}.#{mysql_connector_minor}.tar.gz" do
  source "http://cdn.mysql.com/archives/mysql-connector-java-#{mysql_connector_major}/mysql-connector-java-#{mysql_connector_major}.#{mysql_connector_minor}.tar.gz"
  mode '0644'
  not_if { ::File.exists?("/root/mysql-connector-java-#{mysql_connector_major}.#{mysql_connector_minor}.tar.gz") }
end

bash "extract_connector" do
	code <<-EOH
		tar xvf /root/mysql-connector-java-#{mysql_connector_major}.#{mysql_connector_minor}.tar.gz -C /root/
		mv /root/mysql-connector-java-#{mysql_connector_major}.#{mysql_connector_minor}/mysql-connector-java-#{mysql_connector_major}.#{mysql_connector_minor}-bin.jar /var/opt/idauto/common/lib/
		EOH
	not_if { ::File.exists?("/var/opt/idauto/common/lib/mysql-connector-java-#{mysql_connector_major}.#{mysql_connector_minor}-bin.jar")}
end

# Install Tomcat
remote_file "/root/install-and-configure-tomcat.sh" do
  source "https://s3.amazonaws.com/idauto-apps/install-and-configure-tomcat.sh"
  mode '0755'
  not_if { ::File.exists?("/root/install-and-configure-tomcat.sh") }
end

### Need to break out sh script into separate resources.
execute "install-and-configure-tomcat" do
	command "/root/install-and-configure-tomcat.sh"
	creates "/tmp/install-and-configure-tomcat.done"
	not_if { ::File.exists?("/tmp/install-and-configure-tomcat.done")}
	action :run
end

execute "modify-tomcat-sleep" do
	command "sudo sed -i -e 's/sleep 60/sleep 3/' /etc/init.d/tomcat"
	creates "/tmp/modify-tomcat-sleep.done"
	not_if { ::File.exists?("/tmp/modify-tomcat-sleep.done")}
	action :run
end

remote_file "/root/install-and-configure-apps-and-cron.sh" do
  source "https://s3.amazonaws.com/idauto-apps/install-and-configure-apps-and-cron.sh"
  mode '0755'
  not_if { ::File.exists?("/root/install-and-configure-apps-and-cron.sh") }
end

### This portion has killed sudoers file!  Need to break out sh script into separate resources.
execute "install-and-configure-apps-and-cron.sh" do
	command "/root/install-and-configure-apps-and-cron.sh"
	creates "/tmp/install-and-configure-apps-and-cron.done"
	not_if { ::File.exists?("/tmp/install-and-configure-apps-and-cron.done")}
	action :run
end

