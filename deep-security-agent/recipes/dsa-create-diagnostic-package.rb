#
# Cookbook Name:: deep-security-agent
# Recipe:: Collect a diagnostic package for the Deep Security agent
#
# Copyright 2015, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Ask the Deep Security agent to create a diagnostic package
# *********************************************************************

dsa_args = "-d" # create a diagnostic package and send it to the manager

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