#
# Cookbook:: deep-security-agent
# Attribute:: default
#
# Copyright:: 2017, Trend Micro
#
# License as per [repo](master/LICENSE)
#

########################
# Mandatory attributes #
########################

# As you add agents to Deep Security, they are automatically made available for download through
#   the same hostname:port as the Deep Security Manager admin interface. For Marketplace and software deployments, pass
#   this data through the 'dsm_agent_download_hostname' & 'dsm_agent_download_port' attributes.
default['deep_security_agent']['dsm_agent_download_hostname'] = 'app.deepsecurity.trendmicro.com'
default['deep_security_agent']['dsm_agent_download_port'] = 443

# For Marketplace and software deployments 'ignore_ssl_validation' must to set to 'true' 
#    unless you've installed a verifiable SSL certificate.
default['deep_security_agent']['ignore_ssl_validation'] = false

# Deep Security agents activate on a different port than the admin interface. For Marketplace and
#    software deployments, 'dsm_agent_activation_hostname' is typically the same as 'dsm_agent_download_hostname'
#    but 'dsm_agent_activation_port' is different than 'dsm_agent_download_port'. For Deep Security
#    as a Service, it's the reverse to make it easy to configure only one outbound port.
default['deep_security_agent']['dsm_agent_activation_hostname'] = 'agents.deepsecurity.trendmicro.com'
default['deep_security_agent']['dsm_agent_activation_port'] = 443

# For multi-tenant deployments of Deep Security (such as Deep Security as a Service), every tenant/organization
#    is assigned a unique 'tenant_id' and 'tenant_password' that is only used for agent activation. You can
#    find this info from the Support/Help > Deployment Scripts menu in the Deep Security Manager. Select any agent
#    and then enable "Activate Agent automatically after installation". This places the tenant_id and 
#    tenant_password in the script the wizard is building for you.
default['deep_security_agent']['tenant_id'] = nil
default['deep_security_agent']['token'] = nil


#######################
# Optional attributes #
#######################

# The ID of the policy you want to initialize the agent with. This takes precedence over the 
#    'policy_name' setting. 
default['deep_security_agent']['policy_id'] = nil

# The ID of the relay group you want to initialize the agent with.
default['deep_security_agent']['relaygroup_id'] = nil

# Whether to force re-activation even Deep Security Agent has been activated
default['deep_security_agent']['force_reactivation'] = false