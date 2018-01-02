#
# Cookbook Name:: deep-security-agent
# Recipe:: Install the Deep Security Agent
#
# Copyright 2018, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Install the Deep Security Agent
# *********************************************************************

# Ruby standard lib requirements
require 'tmpdir'

dsm_agent_download_hostname     = node['deep_security_agent']['dsm_agent_download_hostname']
dsm_agent_download_port         = node['deep_security_agent']['dsm_agent_download_port']
ignore_ssl_validation           = node['deep_security_agent']['ignore_ssl_validation']

currentDSAPlatform = detect_DSA_host_platform()

if not currentDSAPlatform.host_platform or not currentDSAPlatform.host_platform_version
  Chef::Log.error('Unsupported platform.')
  exit(false)
else
  Chef::Log.info "Selected #{currentDSAPlatform.host_platform}#{currentDSAPlatform.host_platform_version}/#{currentDSAPlatform.arch_type} as the agent download."
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

local_file_path = "#{tmp_path}/#{currentDSAPlatform.installer_file_name}"
if currentDSAPlatform.host_platform =~ /Windows/
  local_file_path = "#{tmp_path}\\#{currentDSAPlatform.installer_file_name}"
end

agent_download_url = "https://#{dsm_agent_download_hostname}:#{dsm_agent_download_port}/software/agent/#{currentDSAPlatform.host_platform}#{currentDSAPlatform.host_platform_version}/#{currentDSAPlatform.arch_type}/"

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


ruby_block 'check_file_size' do
  block do
    Chef::Log.info "Downloaded DSA installer file size : #{File.size(local_file_path)} bytes"

    if not File.size?(local_file_path)
      Chef::Log.error("Downloaded file size is not valid. There are two possiblities : 1. The OS platform is not supported. 2. Deep Security Manager don't provide agent software package installer for your OS platform.")
      Chef::Log.error('Please verify that agent software package for your platform is available using this reference article https://help.deepsecurity.trendmicro.com/10/0/Get-Started/Install/import-agent-software.html?redirected=true&Highlight=download')
      exit(false)
    end
  end
end


# Install the agent
# ":upgrade" action in RPM and DPKG will do upgrade if downloaded package version is newer than installed. If versions are equals, no action. If older than installed, will throw error.
# Windows package don't support ":upgrade" action, only ":install". It will install if version is not equals. DSA MSI installer will prevent downgrade but allow upgrade. No action is performed if version is equals.
if currentDSAPlatform.installer_file_name =~ /#{PACKAGE_DEB}/
  dpkg_package 'ds_agent' do
    source local_file_path
    action :upgrade
  end
elsif currentDSAPlatform.installer_file_name =~ /#{PACKAGE_RPM}/
  rpm_package 'ds_agent' do
    source local_file_path
    action :upgrade
  end
else
  package 'ds_agent' do
    source local_file_path
    action :install
  end
end
Chef::Log.info 'ds_agent package installed successfully'

# Make sure the service is running
Chef::Log.info 'Making sure that the ds_agent service has started'
begin
  
  service 'ds_agent' do
    action :start
  end
  
  # Block the wait to ensure it's sequential
  ruby_block 'metadata_wait' do
    block do
      Chef::Log.info 'ds_agent service is up and running, pausing to ensure all the local metadata has been collected'
      sleep(15) # this allows the agent to query the AWS metadata URL to gather the environment info
      Chef::Log.info 'ds_agent package installed. ds_agent service is running.'
    end
  end
  
rescue
  Chef::Log.warn 'Could not start the service using the native Chef method'
end