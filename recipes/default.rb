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

#get attributes in handy variable
agent = node['deep-security-agent']


# determine bitness, assume 64-bit but allow for 32-bit when detected
bitness = 64
if node['kernel']['machine'] =~ /32/
	bitness = 32
end


#construct URL
# @TODO need to differentiate between Ubuntu and Debian proper
url = "https://#{agent[:download][:host]}:#{agent[:download][:port]}/software/agent"

platform_major_version = node[:platform_version].split('.').first
case node[:platform_family]

  when 'rhel' #redhat and amazon
		if node[:kernel][:release].include?('amzn')
			url << '/amzn1'
    else
      if platform_major_version == '4'
				url << "/RedHat_2.6.9_22.EL_#{bitness == 64 ? 'x86_64' : 'i686'}"
      else
				url << "/RedHat_EL#{platform_major_version}"
      end
    end

  when 'suse'
		url << "/SuSE_#{platform_major_version}"

	when 'windows'
		url << '/Windows'

	when 'debian'
		url << "/Ubuntu_#{platform_major_version}.04"

	else
		raise 'Unsupported platform family ' + node[:platform_family]
end

url << "#{bitness == 64 ? '/x86_64/' : '/i386/'}"



#determine local file path
case node[:platform_family]
	when 'rhel', 'suse'
		local_file_name = 'ds_agent.rpm'
	when 'windows'
		local_file_name = 'ds_agent.msi'
	when 'debian'
		local_file_name = 'ds_agent.deb'
	else
		raise 'Unsupported platform family ' + node[:platform_family]
end

local_file_path = "#{Chef::Config['file_cache_path']}/#{local_file_name}"



# Download the agent
Chef::Log.info "downloading #{url} to #{local_file_path} as the based on Ohai reporting: #{node[:platform_family]}, #{node[:platform_version]}, #{node[:kernel][:release]}}"
if agent[:download][:ignore_ssl]
  ruby_block 'download_'+local_file_path do
    block do
      open(local_file_path, 'wb') do |file|
        file << open(URI.parse(url), {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
      end
    end
  end
else
	remote_file local_file_path do
	    source url
	    action :create
	end
end



#install agent package
case node[:platform_family]
  when 'rhel', 'suse'
    rpm_package "ds_agent" do
      source local_file_path
      action :install
    end
  when 'windows'
    package "ds_agent" do
      source local_file_path
      action :install
    end
  when 'debian'
    dpkg_package "ds_agent" do
      source local_file_path
      action :install
    end
  else
    raise 'Unsupported platform family ' + node[:platform_family]
end
Chef::Log.info "ds_agent package installed successfully"



# Make sure the service is running
Chef::Log.info "Making sure that the ds_agent service has started"
begin
	service "ds_agent" do
    action :start
  end
	Chef::Log.info "ds_agent service is up and running, pausing to ensure all the local metadata has been collected"
rescue
	Chef::Log.warning "Could not start the service using the native Chef method"
end



# Block the wait to ensure it's sequential
ruby_block 'metadata_wait' do
	block do
		sleep(15) # this allows the agent to query the AWS metadata URL to gather the environment info
	end
end
Chef::Log.info "ds_agent package installed. ds_agent service is running. Ready to activate"



# Activate the agent
dsa_args = "-a dsm://#{agent[:activation][:hostname]}:#{agent[:activation][:port]}/"

if agent[:tenant_id] and agent[:tenant_password]
	dsa_args << " \"tenantID:#{agent[:tenant_id]}\" \"tenantPassword:#{agent[:tenant_password]}\""
end

if agent[:activation][:sethost]
  dsa_args << " hostname:#{agent[:activation][:sethost] }"
end

if agent[:policy_id]
	dsa_args << " \"policyid:#{agent[:policy_id]}\""
elsif agent[:policy_name]
	dsa_args << " \"policy:#{agent[:policy_name]}\""
end

dsa_control('-r',     'activate-r')
dsa_control(dsa_args, 'activate')

Chef::Log.info("Activated the Deep Security agent")