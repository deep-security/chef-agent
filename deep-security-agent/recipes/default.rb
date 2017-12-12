#
# Cookbook Name:: deep-security-agent
# Recipe:: Deploy the Deep Security agent
#
# Copyright 2015, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Install the Deep Security Agent
# *********************************************************************

# Ruby standard lib requirements
require 'tmpdir'

dsm_agent_download_hostname 	= node['deep_security_agent']['dsm_agent_download_hostname']
dsm_agent_download_port 		= node['deep_security_agent']['dsm_agent_download_port']
ignore_ssl_validation 			= node['deep_security_agent']['ignore_ssl_validation']
dsm_agent_activation_hostname 	= node['deep_security_agent']['dsm_agent_activation_hostname']
dsm_agent_activation_port 		= node['deep_security_agent']['dsm_agent_activation_port']
tenant_id 						= node['deep_security_agent']['tenant_id']
token 				            = node['deep_security_agent']['token']
policy_id 						= node['deep_security_agent']['policy_id']

PACKAGE_RPM = 'ds_agent.rpm'.freeze
PACKAGE_DEB = 'ds_agent.deb'.freeze
PACKAGE_MSI = 'ds_agent.msi'.freeze

# Determine the correct agent based on information reported by Ohai
host_platform = nil
host_platform_version = nil
installer_file_name = nil
case node[:platform]
when /amazon/
  host_platform = 'amzn'
  host_platform_version = '1'
  installer_file_name = PACKAGE_RPM
when /redhat/, /centos/
  host_platform = 'RedHat_EL'
  host_platform_version = "#{/(\d+)/.match(node[:platform_version])[1]}"
  installer_file_name = PACKAGE_RPM
when /suse/
  host_platform = 'SuSE_'
  host_platform_version = "#{/(\d+)/.match(node[:platform_version])[1]}"
  installer_file_name = PACKAGE_RPM
when /debian/
  host_platform = 'Debian_'
  host_platform_version = "#{/(\d+)/.match(node[:platform_version])[1]}"
  installer_file_name = PACKAGE_DEB
when /ubuntu/
  host_platform = 'Ubuntu_'
  host_platform_version = "#{/(\d+)/.match(node[:platform_version])[1]}.04"
  installer_file_name = PACKAGE_DEB
when /windows/
  host_platform = 'Windows'
  host_platform_version = ''
  installer_file_name = PACKAGE_MSI
when /oracle/, /enterpriseenterprise/
  host_platform = 'Oracle_OL'
  host_platform_version = "#{/(\d+)/.match(node[:platform_version])[1]}"
  installer_file_name = PACKAGE_RPM
when /cloudlinux/
  host_platform = 'CloudLinux_'
  host_platform_version = "#{/(\d+)/.match(node[:platform_version])[1]}"
  installer_file_name = PACKAGE_RPM
end

# assume 64-bit but allow for 32-bit when detected
arch_type = 'x86_64'
if node['kernel']['machine'] =~ /32/
  arch_type = 'i386'
end

Chef::Log.info "Ohai reporting: #{node[:platform]}, #{node[:platform_version]}, #{node[:kernel][:machine]}"

if not host_platform or not host_platform_version
  Chef::Log.error('Unsupported platform.')
  exit(false)
else
  Chef::Log.info "Selected #{host_platform}#{host_platform_version}/#{arch_type} as the agent download."
end

# Get the URL and local path setup
tmp_path = ''
if ENV.has_key?('TMPDIR')
  tmp_path = ENV['TMPDIR']
elsif tmp_path = ENV['TMP']
  tmp_path = ENV['TMP']
elsif tmp_path = ENV['TEMP']
  tmp_path = ENV['TEMP']
else
  tmp_path = Dir.tmpdir()
end
Chef::Log.info "Tmp folder determined to be [#{tmp_path}]"

local_file_path = "#{tmp_path}/#{installer_file_name}"
if host_platform =~ /Windows/
  local_file_path = "#{tmp_path}\\#{installer_file_name}"
end

agent_download_url = "https://#{dsm_agent_download_hostname}/software/agent/#{host_platform}#{host_platform_version}/#{arch_type}/"

Chef::Log.info "Local file: #{local_file_path}"
Chef::Log.info "URL: #{agent_download_url}"

# Download the agent
if ignore_ssl_validation
  open(local_file_path, 'wb') do |file|
    request_uri=URI.parse(agent_download_url)
    file << open(request_uri, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
  end
else
  remote_file local_file_path do
    source agent_download_url
    action :create
  end
end

Chef::Log.info "Downloaded DSA installer file size : #{File.size(local_file_path)} bytes"

if not File.size?(local_file_path)
  Chef::Log.error("Downloaded file size is not valid. There are two possiblities : 1. The OS platform is not supported. 2. Deep Security Manager don't provide agent software package installer for your OS platform.")
  Chef::Log.error('Please verify that agent software package for your platform is available using this reference article https://help.deepsecurity.trendmicro.com/10/0/Get-Started/Install/import-agent-software.html?redirected=true&Highlight=download')
  exit(false)
end

# Install the agent
if installer_file_name =~ /#{PACKAGE_DEB}/
  dpkg_package 'ds_agent' do
    source local_file_path
    action :install
  end
elsif installer_file_name =~ /#{PACKAGE_RPM}/
  rpm_package 'ds_agent' do
    source local_file_path
    action :install
  end
else
  package 'ds_agent' do
    source local_file_path
    action :install
  end
end
Chef::Log.info 'ds_agent package installed successfully'


# Wait for the metadata to load
sleep(5) # this allows the agent to query the AWS metadata URL to gather the environment info

# Make sure the service is running
Chef::Log.info 'Making sure that the ds_agent service has started'
begin
  service 'ds_agent' do
    action :start
  end
rescue
  Chef::Log.warn 'Could not start the service using the native Chef method'
end

Chef::Log.info 'ds_agent service is up and running, pausing to ensure all the local metadata has been collected'
# Block the wait to ensure it's sequential
ruby_block 'metadata_wait' do
  block do
    sleep(15) # this allows the agent to query the AWS metadata URL to gather the environment info
  end
end
Chef::Log.info 'ds_agent package installed. ds_agent service is running. Ready to activate'

# Activate the agent
dsa_args = "-a dsm://#{dsm_agent_activation_hostname}:#{dsm_agent_activation_port}/"
if !tenant_id.to_s.empty? and !token.to_s.empty?
  dsa_args << " \"tenantID:#{tenant_id}\" \"tenantPassword:#{token}\""
end

if policy_id
  dsa_args << " \"policyid:#{policy_id}\""
end

Chef::Log.info "Running dsa_control with args: #{dsa_args}"

if host_platform =~ /Windows/
  powershell_script 'activate_ds_agent' do
    code <<-EOH
    & $Env:ProgramFiles"\\Trend Micro\\Deep Security Agent\\dsa_control" -r
    & $Env:ProgramFiles"\\Trend Micro\\Deep Security Agent\\dsa_control" #{dsa_args}
    EOH
  end
else
  execute 'activate_ds_agent' do
    command '/opt/ds_agent/dsa_control -r'
  end
  execute 'activate_ds_agent' do
    command "/opt/ds_agent/dsa_control #{dsa_args}"
  end
end
Chef::Log.info('Activated the Deep Security agent')