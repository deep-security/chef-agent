#
# Cookbook Name:: deep-security-agent
# Recipe:: Build an integrity baseline for the node
#
# Copyright 2015, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Create an integrity baseline for the current node
# *********************************************************************

dsa_args = "--buildBaseline" # create an integrity baseline and send it to the manager

if node[:platform_family] =~ /win/
	powershell_script 'prompt_ds_agent' do
	  code <<-EOH
		& $Env:ProgramFiles"\\Trend Micro\\Deep Security Agent\\dsa_control" #{dsa_args}
	  EOH
	end
else
	execute 'prompt_ds_agent' do
		command "/opt/ds_agent/dsa_control #{dsa_args}"
	end
end
Chef::Log.info "The Deep Security agent will check in with the manager shortly"