
#
# Cookbook Name:: workload-security-agent
# Recipe:: get-deployment-script
#
# Copyright 2020, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Download Workload Security Agent Deployment Script
# *********************************************************************

# Initialize hashes
params = {}
params['headers'] = {}
params['body'] = {}
response = nil

# Construct request headers.
%w(Content-Type API-Version).each do |key|
  params['headers'][key] = node['workload-security-agent']['deployment-script']['headers'][key]
end

# Construct request body.
%w(platform validateCertificateRequired validateDigitalSignatureRequired activationRequired dsmProxyID relayProxyID policyID relayGroupID computerGroupID).each do |key|
  # Only add to hash if the key is not empty.
  params['body'][key] = node['workload-security-agent']['deployment-script']['body'][key] if node['workload-security-agent']['deployment-script']['body'][key] != ''
end

ruby_block 'Get deployment script' do
  block do
    # Add api-secret-key to headers. This is done in the ruby block so that this happens in the execution phase.
    params['headers']['API-Secret-Key'] = node.run_state['api-secret-key']

    # Send REST request and capture response.
    begin
      response = Chef::HTTP.new(node['workload-security-agent']['api']['url']).post(
        node['workload-security-agent']['deployment-script']['endpoint'],
        params['body'].to_json,
        params['headers']
        )
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError, Net::HTTPServerException => e
      raise "#{e.response.code}: #{e.response.header}: #{e.response.body}"
    rescue Exception => e
      raise e
    end

    # Check whether the key in question is present.
    if response.nil? || !JSON.parse(response).key?('scriptBody')
      raise "No scriptBody in JSON response."
    end
  end
  not_if {::File.exists?(node['workload-security-agent']['deployment-script']['outfile'])}
  notifies :create, "template[#{node['workload-security-agent']['deployment-script']['outfile']}]", :immediately
end

# Write response to file
template node['workload-security-agent']['deployment-script']['outfile'] do
  mode "0755"
  source "AgentDeploymentScript.sh.erb"
  variables(
    lazy {
      {script_body: JSON.parse(response)['scriptBody']}
    }
  )
  not_if {::File.exists?(node['workload-security-agent']['deployment-script']['outfile'])}
end