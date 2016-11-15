#
# Cookbook Name:: deep-security-agent
# Recipe:: Recommend a security policy for the node
#
# Copyright 2015, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Recommend a security policy for the node
# *********************************************************************

dsa_args = "-m \"RecommendationScan:true\"" # create an integrity baseline and send it to the manager

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