#
# Cookbook Name:: workload-security-agent
# Recipe:: run-deployment-script
#
# Copyright 2020, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Run Workload Security Agent Deployment Script
# *********************************************************************

execute 'Install agent' do
  command "sudo bash #{node['workload-security-agent']['deployment-script']['outfile']}"
  live_stream true
  not_if { `sudo /opt/ds_agent/dsa_control -m`.match(/HTTP Status: 200/) }
end