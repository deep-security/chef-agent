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

# Expected attributes:
# {
#    "dsm_agent_download_hostname": "app.deepsecurity.trendmicro.com",
#    "dsm_agent_download_port": 443,
#    "ignore_ssl_validation": false,
#    "dsm_agent_activation_hostname": "agents.deepsecurity.trendmicro.com",
#    "dsm_agent_activation_port": 443,
#    "tenant_id": "111A111A-1A1A-11AA-AAA-11AA11111111",
#    "tenant_password": "111A111A-1A1A-11AA-AAA-11AA11111111",
#    "policy_id": 1,
#    "policy_name": "Base Policy"
# }

# Ensure that we have a full configuration

# As you add agents to Deep Security, they are automatically made available for download through
#   the same hostname:port as the admin interface. For Marketplace AMI and software deployments, pass
#   this data through the 'dsm_agent_download_hostname' & 'dsm_agent_download_port' attributes
dsm_agent_download_hostname = node.has_key?(:dsm_agent_download_hostname) ? node[:dsm_agent_download_hostname] : "app.deepsecurity.trendmicro.com"
dsm_agent_download_port = node.has_key?(:dsm_agent_download_port) ? node[:dsm_agent_download_port] : 443
# For Marketplace AMI and software deployments 'ignore_ssl_validation' must to set to 'true' 
#    unless you've installed a verifiable SSL certificate
ignore_ssl_validation = node.has_key?(:ignore_ssl_validation) ? node[:ignore_ssl_validation] : false

# Deep Security agents activate on a different port then the admin interface. For Marketplace AMI and
#    software deployments, 'dsm_agent_activation_hostname' is typically the same as 'dsm_agent_download_hostname'
#    but 'dsm_agent_activation_port' will be different then 'dsm_agent_download_port'. For Deep Security
#    as a Service, it's the reverse to make it easy to configure only one outbound port
dsm_agent_activation_hostname = node.has_key?(:dsm_agent_activation_hostname) ? node[:dsm_agent_activation_hostname] : "agents.deepsecurity.trendmicro.com"
dsm_agent_activation_port = node.has_key?(:dsm_agent_activation_port) ? node[:dsm_agent_activation_port] : 443

# For multi-tenant deployments of Deep Security (such as Deep Security as a Service), every tenant/organization
#    is assigned a unique 'tenant_id' and 'tenant_password' that is only used for agent activation. You can
#    find this info from the Support/Help > Deployment Scripts menu option in the admin. Select any agent
#    and then check "Activate Agent automatically after installation". This will put the tenant_id and 
#    tenant_password in the script the wizard is building for you
tenant_id = node.has_key?(:tenant_id) ? node[:tenant_id] : nil
tenant_password = node.has_key?(:tenant_password) ? node[:tenant_password] : nil

# The ID of the policy you want to initialize the agent with. This takes precedence over the 
#    'policy_name' setting. 
policy_id = node.has_key?(:policy_id) ? node[:policy_id] : nil
# The name of the policy you want to initialize the agent with. This needs to be an exact string 
#    match in order to be applied. policy_id is a little more robust option (as you can change 
#    the name anytime you want) but you need to do a little more work to get the ID of the policy
policy_name = node.has_key?(:policy_name) ? node[:policy_name] : nil

# Matrix of agents to downloaded based on OS
agent_download_info = {
	"amzn" => {
		"fn" => "ds_agent.rpm",
		32 => "https://#{dsm_agent_download_hostname}/software/agent/amzn1/i386/",
		64 => "https://#{dsm_agent_download_hostname}/software/agent/amzn1/x86_64/",
		},
	"rhel_4" => {
		"fn" => "ds_agent.rpm",
		32 => "https://#{dsm_agent_download_hostname}/software/agent/RedHat_2.6.9_22.EL_i686/i386/",
		64 => "https://#{dsm_agent_download_hostname}/software/agent/RedHat_2.6.9_34.EL_x86_64/x86_64/",
		},
	"rhel_5" => {
		"fn" => "ds_agent.rpm",
		32 => "https://#{dsm_agent_download_hostname}/software/agent/RedHat_EL5/i386/",
		64 => "https://#{dsm_agent_download_hostname}/software/agent/RedHat_EL5/x86_64/",
		},
	"rhel_6" => {
		"fn" => "ds_agent.rpm",
		32 => "https://#{dsm_agent_download_hostname}/software/agent/RedHat_EL6/i386/",
		64 => "https://#{dsm_agent_download_hostname}/software/agent/RedHat_EL6/x86_64/",
		},
	"rhel_7" => {
		"fn" => "ds_agent.rpm",
		64 => "https://#{dsm_agent_download_hostname}/software/agent/RedHat_EL7/x86_64/",
		},		
	"suse_10" => {
		"fn" => "ds_agent.rpm",
		32 => "https://#{dsm_agent_download_hostname}/software/agent/SuSE_10/i386/",
		64 => "https://#{dsm_agent_download_hostname}/software/agent/SuSE_10/x86_64/",
		},
	"suse_11" => {
		"fn" => "ds_agent.rpm",
		32 => "https://#{dsm_agent_download_hostname}/software/agent/SuSE_11/i386/",
		64 => "https://#{dsm_agent_download_hostname}/software/agent/SuSE_11/x86_64/",
		},
	"suse_12" => {
		"fn" => "ds_agent.rpm",
		64 => "https://#{dsm_agent_download_hostname}/software/agent/SuSE_12/x86_64/",
		},				
	"win" => {
		"fn" => "ds_agent.msi",
		32 => "https://#{dsm_agent_download_hostname}/software/agent/Windows/i386/",
		64 => "https://#{dsm_agent_download_hostname}/software/agent/Windows/x86_64/",
		},
	"ubuntu_10" => {
		"fn" => "ds_agent.deb",
		64 => "https://#{dsm_agent_download_hostname}/software/agent/Ubuntu_10.04/x86_64/",
		},
	"ubuntu_12" => {
		"fn" => "ds_agent.deb",
		64 => "https://#{dsm_agent_download_hostname}/software/agent/Ubuntu_12.04/x86_64/",
		},
	"ubuntu_14" => {
		"fn" => "ds_agent.deb",
		64 => "https://#{dsm_agent_download_hostname}/software/agent/Ubuntu_14.04/x86_64/",
		},	
	}

# Determine the correct agent based on information reported by Ohai
agent_download_key = "amzn"
case node[:platform_family]
when /rhel/
	if node[:kernel][:release].include?("amzn")
		agent_download_key = "amzn"
	else
		agent_download_key = "rhel_#{/(\d+)/.match(node[:platform_version])[0]}"
	end
when /suse/
	agent_download_key = "suse_#{/(\d+)/.match(node[:platform_version])[0]}"
when /debian/
	# @TODO need to differentiate between Ubuntu and Debian proper
	agent_download_key = "ubuntu_#{/(\d+)/.match(node[:platform_version])[0]}"	
when /win/
	agent_download_key = "win"
else
	# try the RHEL agent as it seems to be the most common
	agent_download_key = "rhel_6"
end

# assume 64-bit but allow for 32-bit when detected
bitness = 64
if node['kernel']['machine'] =~ /32/
	bitness = 32
end
Chef::Log.info "Selected #{agent_download_key}/#{bitness} as the agent download based on Ohai reporting: #{node[:platform_family]}, #{node[:platform_version]}, #{node[:kernel][:release]}}"

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
local_file_path = "#{tmp_path}/#{agent_download_info[agent_download_key]['fn']}"
if agent_download_key =~ /win/
	local_file_path = "#{tmp_path}\\#{agent_download_info[agent_download_key]['fn']}"
end

agent_download_url = "#{agent_download_info[agent_download_key][bitness]}"

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
	    action :create_if_missing
	end
end

# Install the agent
if agent_download_key =~ /ubuntu/
	dpkg_package "ds_agent" do
	  source local_file_path
	  action :install
	end
elsif agent_download_key =~ /suse/
	rpm_package "ds_agent" do
	  source local_file_path
	  action :install
	end
else
	package "ds_agent" do
	  source local_file_path
	  action :install
	end
end
Chef::Log.info "ds_agent package installed successfully"


def configured?
  @configured ||= begin
	  so = Mixlib::ShellOut.new("/opt/ds_agent/dsa_control -m")
	  so.run_command
	  so.stdout =~ /HTTP\sStatus\:\s200/im
	end
end

if configured?

	Chef::Log.info "Skipping configuration because it is already configured"

else

	# Wait for the metadata to load
	sleep(5) # this allows the agent to query the AWS metadata URL to gather the environment info

	# Make sure the service is running
	Chef::Log.info "Making sure that the ds_agent service has started"
	begin
		service "ds_agent" do
	    action :start
		end
	rescue
		Chef::Log.warning "Could not start the service using the native Chef method"
	end

	Chef::Log.info "ds_agent service is up and running, pausing to ensure all the local metadata has been collected"
	# Block the wait to ensure it's sequential
	ruby_block 'metadata_wait' do
		block do
			sleep(15) # this allows the agent to query the AWS metadata URL to gather the environment info
		end
	end
	Chef::Log.info "ds_agent package installed. ds_agent service is running. Ready to activate"

	# Activate the agent
	dsa_args = "-a dsm://#{dsm_agent_activation_hostname}:#{dsm_agent_activation_port}/"
	if tenant_id and tenant_password
		dsa_args << " \"tenantID:#{tenant_id}\" \"tenantPassword:#{tenant_password}\""
	end
	if policy_id
		dsa_args << " \"policyid:#{policy_id}\""
	elsif policy_name
		dsa_args << " \"policy:#{policy_name}\""
	end
	Chef::Log.info "Running dsa_control with args: #{dsa_args}"

	if agent_download_key =~ /win/
		powershell_script 'activate_ds_agent' do
		  code <<-EOH
		  & $Env:ProgramFiles"\\Trend Micro\\Deep Security Agent\\dsa_control" -r
			& $Env:ProgramFiles"\\Trend Micro\\Deep Security Agent\\dsa_control" #{dsa_args}
		  EOH
		end
	else
		execute "activate_ds_agent" do
			command "/opt/ds_agent/dsa_control -r"
		end	
		execute "activate_ds_agent" do
			command "/opt/ds_agent/dsa_control #{dsa_args}"
		end	
	end
	Chef::Log.info("Activated the Deep Security agent")

end
