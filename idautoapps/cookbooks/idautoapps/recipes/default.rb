#
# Cookbook Name:: idautoapps
# Recipe:: install_packages
#
# Copyright 2014, Identity Automation, LP
#
# All rights reserved - Do Not Redistribute
#

###@@@  STATUS: Recipe believed to contain everything.  Current errors are expectec due to no database.

###########################################################################
# Variables                                                               #
###########################################################################
timezone = "America/Chicago"
mysql_connector_major = "5.1"
mysql_connector_minor = "33"
tomcat_version = "7.0.56"
root_version = "1.0.2"
idautoapps_version = "3.1.5.3.10"

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

# Install LDAP client package
package "net-snmp" do
	action :install
end

# Install LDAP client package
package "net-snmp-utils" do
	action :install
end

###########################################################################
# Manage directories                                                      #
###########################################################################
directory "/root/results" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

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
# Set timezone                                                            #
###########################################################################
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
# Manage users                                                            #
###########################################################################
# Create config user
user "config" do
	action :create
	comment "IdAuto Appliance configuration account"
	shell "/bin/false"
	password "$6$9wQiDrR3$hreGbkwNaPBqLPP2n/HbEeKMNlxt/Bq9.WQcTe7mvZh9LX0orrJ8TQixYqt.M9eEaqH5N.xSDJliLaC1ownii0"
end

# Prepare config menu
file "/var/opt/idauto/menu/menu.sh" do
	mode "0755"
	action :create_if_missing
end

# Modify config user shell
user "config" do
	shell "/var/opt/idauto/menu/menu.sh"
	action :create
end

# Create tomcat user
user "tomcat" do
	action :create
	comment "Tomcat system user"
	password "$6$NAsj56eO$rqhXtqlzGaHmj9qAJQgUH8HImdXc0TDGiOptdBr9T1OV1NyC3oDPBMiVorAxVxAhRKNFV6gbIgl7eLEqdyFYm0"
end

###########################################################################
# Modify SSH                                                              #
###########################################################################
execute "ssh-permitrootlogin" do
	command "sudo sed -i 's|^PermitRootLogin forced-commands-only|\\#PermitRootLogin forced-commands-only|g' /etc/ssh/sshd_config"
	creates "/root/results/ssh-permitrootlogin.done"
	not_if { ::File.exists?("/root/results/ssh-permitrootlogin.done")}
	action :run
end

execute "ssh-maxauthtries" do
	command "sudo sed -i 's|^#MaxAuthTries 6|\\MaxAuthTries 30|g' /etc/ssh/sshd_config"
	creates "/root/results/ssh-maxauthtries.done"
	not_if { ::File.exists?("/root/results/ssh-maxauthtries.done")}
	action :run
end

directory "/root/.ssh" do
	action :create
end

execute "copy_authorized_keys" do
	command "sudo cp ~ec2-user/.ssh/authorized_keys /root/.ssh/"
	creates "/root/results/copy_authorized_keys.done"
	not_if { ::File.exists?("/root/results/copy_authorized_keys.done")}
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
	creates "/root/results/install_winexe.done"
	not_if { ::File.exists?("/root/results/install_winexe.done")}
	action :run
end

# Install Java
execute "install_java" do
	command "sudo rpm -qa | grep -qw jre || rpm -ivh https://s3.amazonaws.com/idauto-apps/jre-7u71-linux-x64.rpm"
	creates "/root/results/install_java.done"
	not_if { ::File.exists?("/root/results/install_java.done")}
	action :run
end

execute "enable_java" do
	command "sudo /usr/sbin/alternatives --install /usr/bin/java java /usr/java/latest/bin/java 20000"
	creates "/root/results/enable_java.done"
	not_if { ::File.exists?("/root/results/enable_java.done")}
	action :run
end

execute "keytool_symlink" do
	command "sudo ln -s /usr/java/latest/bin/keytool /usr/bin/keytool"
	creates "/root/results/keytool_symlink.done"
	not_if { ::File.exists?("/root/results/keytool_symlink.done")}
	action :run
end

# Install MySQL Connector
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

###########################################################################
# Configure SNMP Monitoring                                               #
###########################################################################
# Download SNMP configuration
remote_file "/etc/snmp/snmpd.conf" do
  source "http://s3.amazonaws.com/idauto-apps/snmpd.conf"
  mode '0644'
end

# Restart SNMP service
service "snmpd" do
	supports :status => true, :restart => true, :reload => true
	action [ :enable, :restart ]
end

###########################################################################
# Install and Configure Tomcat                                            #
###########################################################################
# Download Tomcat
remote_file "/root/apache-tomcat-#{tomcat_version}.zip" do
  source "https://s3.amazonaws.com/idauto-apps/apache-tomcat-#{tomcat_version}.zip"
  mode '0755'
  not_if { ::File.exists?("/root/apache-tomcat-#{tomcat_version}.zip") }
end

# Deploy Tomcat
bash "deploy_tomcat" do
	code <<-EOH
		unzip -o /root/apache-tomcat-#{tomcat_version}.zip -d /srv
		mv /srv/`basename /root/apache-tomcat-#{tomcat_version}.zip .zip` /srv/tomcat7
		touch /srv/tomcat7/logs/catalina.out
		ln -s /srv/tomcat7/logs/catalina.out /var/opt/idauto/logs/tomcat.log
		rm -rf /srv/tomcat7/bin/*.bat
		EOH
	creates "/root/results/deploy_tomcat_#{tomcat_version}.done"
	not_if { ::File.exists?("/root/results/deploy_tomcat_#{tomcat_version}.done")}
end

# Download Tomcat configuration files
remote_file "/etc/init.d/tomcat" do
  source "https://s3.amazonaws.com/idauto-apps/tomcat_init.d"
  mode '0755'
end

remote_file "/etc/logrotate.d/tomcat" do
  source "https://s3.amazonaws.com/idauto-apps/tomcat_logrotate"
  mode '0644'
end

remote_file "/var/opt/idauto/certs/tomcat_keystore.jks" do
  source "https://s3.amazonaws.com/idauto-apps/tomcat_keystore.jks"
  mode '0644'
end

remote_file "/srv/tomcat7/conf/server.xml" do
  source "https://s3.amazonaws.com/idauto-apps/server.xml"
  mode '0644'
end

remote_file "/srv/tomcat7/conf/catalina.properties" do
  source "https://s3.amazonaws.com/idauto-apps/catalina.properties"
  mode '0644'
end

remote_file "/srv/tomcat7/lib/catalina-jmx-remote.jar" do
  source "https://s3.amazonaws.com/idauto-apps/catalina-jmx-remote.jar"
  mode '0644'
end

remote_file "/var/opt/idauto/common/jmxremote.access" do
  source "https://s3.amazonaws.com/idauto-apps/jmxremote.access"
  mode '0644'
end

remote_file "/var/opt/idauto/common/jmxremote.password" do
  source "https://s3.amazonaws.com/idauto-apps/jmxremote.password"
  mode '0644'
end

# Make Tomcat binaries executable
execute "tomcat-binaries-executable" do
	command "sudo chmod +x -R /srv/tomcat7/bin"
	action :run
end

# Modify ownership of tomcat directory
execute "tomcat-user-ownership" do
	command "sudo chown tomcat:tomcat -R /srv/tomcat7"
	action :run
end

# Modify tomcat sleep settings
execute "modify-tomcat-sleep" do
	command "sudo sed -i -e 's/sleep 60/sleep 3/' /etc/init.d/tomcat"
	creates "/root/results/modify-tomcat-sleep.done"
	not_if { ::File.exists?("/root/results/modify-tomcat-sleep.done")}
	action :run
end

# Tomcat service
service "tomcat" do
	supports :status => true, :restart => true, :reload => true
	action [ :enable, :start ]
end

###########################################################################
# Configure Base Apps                                                     #
###########################################################################
# Install ROOT
remote_file "/root/ROOT-#{root_version}.zip" do
  source "http://downloads.identitymgmt.net/bundles/ROOT-#{root_version}.zip"
  mode '0755'
  not_if { ::File.exists?("/root/ROOT-#{root_version}.zip") }
end

execute "deploy-root-app" do
	command "sudo unzip -o /root/ROOT-#{root_version}.zip -d /var/opt/idauto/webapps"
	creates "/root/results/deploy-root-#{root_version}.done"
	not_if { ::File.exists?("/root/results/deploy-root-#{root_version}.done")}
	action :run
end

# Install Appliance Manager
remote_file "/root/idauto-apps-#{idautoapps_version}.zip" do
  source "http://downloads.identitymgmt.net/bundles-30/idauto-apps-#{idautoapps_version}.zip"
  mode '0755'
  not_if { ::File.exists?("/root/idauto-apps-#{idautoapps_version}.zip") }
end

execute "deploy-idautoapps-app" do
	command "sudo unzip -o /root/idauto-apps-#{idautoapps_version}.zip -d /var/opt/idauto/webapps"
	creates "/root/results/deploy-idautoapps-#{idautoapps_version}.done"
	not_if { ::File.exists?("/root/results/deploy-idautoapps-#{idautoapps_version}.done")}
	action :run
end

# Modify ownership of idauto directory
execute "idauto-user-ownership" do
	command "sudo chown tomcat:tomcat -R /var/opt/idauto"
	action :run
end

###########################################################################
# Configure sudoers                                                       #
###########################################################################
# Install config user sudoers files
remote_file "/var/opt/idauto/menu/sudoers.config" do
  source "https://s3.amazonaws.com/idauto-apps/sudoers.config"
  owner "root"
  group "root"
  mode '0440'
end

# Install tomcat user sudoers files
remote_file "/var/opt/idauto/tomcat/sudoers.tomcat" do
  source "https://s3.amazonaws.com/idauto-apps/sudoers.tomcat"
  owner "root"
  group "root"
  mode '0440'
end

# Replace sudoers file
remote_file "/etc/sudoers" do
  source "https://s3.amazonaws.com/idauto-apps/sudoers"
  mode '0440'
end

###########################################################################
# Reboot Now                                                              #
###########################################################################
###@@@  Chef didn't like the :nothing action so have to figure out a way to only reboot on first run
#reboot "on_first_install" do
#  action :nothing
#  reason "Reboot after basic IdAuto Appliance setup."
#end

#execute "reboot_after_install" do
#  creates "/root/results/reboot_after_install.done"
#  notifies :reboot_now, 'reboot[on_first_install]', :immediately
#  not_if { ::File.exists?("/root/results/reboot_after_install.done")}
#end
