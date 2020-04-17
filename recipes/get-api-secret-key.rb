#
# Cookbook Name:: workload-security-agent
# Recipe:: get-api-secret-key
#
# Copyright 2020, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Get the API Secret Key, either as a chef attribute, or from AWS SSM
# *********************************************************************

node.run_state['api-secret-key'] = node['workload-security-agent']['api']['secret']['key']
# If secret supplied is empty.
if node['workload-security-agent']['api']['secret']['key'].empty?
  # If provider is set to aws-ssm, then get it from parameter store.
  if node['workload-security-agent']['api']['secret']['provider'] == 'aws-ssm'
    aws_ssm_parameter_store 'Get API secret key' do
      path node['workload-security-agent']['api']['secret']['aws-ssm']['path']
      return_key 'api-secret-key'
      with_decryption node['workload-security-agent']['api']['secret']['aws-ssm']['with-decryption']
      action :get
    end
  end
end