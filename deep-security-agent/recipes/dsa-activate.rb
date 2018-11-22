#
# Cookbook Name:: deep-security-agent
# Recipe:: Activate the Deep Security agent
#
# Copyright 2018, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Activate the Deep Security Agent
# *********************************************************************

dsm_agent_activation_hostname   = node['deep_security_agent']['dsm_agent_activation_hostname']
dsm_agent_activation_port       = node['deep_security_agent']['dsm_agent_activation_port']
tenant_id                       = node['deep_security_agent']['tenant_id']
token                           = node['deep_security_agent']['token']
policy_id                       = node['deep_security_agent']['policy_id']

# Activate the agent
Chef::Log.info 'Starting to activate ds_agent.'

dsa_args = "-a dsm://#{dsm_agent_activation_hostname}:#{dsm_agent_activation_port}/"
if !tenant_id.to_s.empty?
  dsa_args << " \"tenantID:#{tenant_id}\""
end

if !token.to_s.empty?
  dsa_args << " \"tenantPassword:#{token}\""
end

if policy_id
  dsa_args << " \"policyid:#{policy_id}\""
end

Chef::Log.info "Running dsa_control with args: #{dsa_args}"

currentDSAPlatform = detect_DSA_host_platform()

Chef::Log.info "Forced reactivation : #{node['deep_security_agent']['force_reactivation']}"

if currentDSAPlatform.host_platform =~ /Windows/
  powershell_script 'activate_ds_agent' do
    code <<-EOH
    & $Env:ProgramFiles"\\Trend Micro\\Deep Security Agent\\dsa_control" -r
    & $Env:ProgramFiles"\\Trend Micro\\Deep Security Agent\\dsa_control" #{dsa_args}
    EOH
    only_if { !is_DSA_activated?() || node['deep_security_agent']['force_reactivation'] }
  end
else
  execute 'activate_ds_agent' do
    command '/opt/ds_agent/dsa_control -r'
    only_if { !is_DSA_activated?() || node['deep_security_agent']['force_reactivation'] }
  end
  execute 'activate_ds_agent' do
    command "/opt/ds_agent/dsa_control #{dsa_args}"
    only_if { !is_DSA_activated?() || node['deep_security_agent']['force_reactivation'] }
  end
end
Chef::Log.info('Activated the Deep Security agent')
