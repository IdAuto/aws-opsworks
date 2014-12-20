#
# Cookbook Name:: idautoapps
# Recipe:: manage_users
#
# Copyright 2014, Identity Automation, LP
#
# All rights reserved - Do Not Redistribute
#

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
