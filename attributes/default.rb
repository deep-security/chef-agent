# deep-security-agent cookbook attributes

# ensure that chef-vault databag fallback is disabled by default
default['chef-vault']['databag_fallback'] = false

agent = default['deep-security-agent']

agent[:download_hostname]   = 'app.deepsecurity.trendmicro.com'
agent[:download_port]       = '443'
agent[:download_ignore_ssl] = false

agent[:activation_hostname] = 'agents.deepsecurity.trendmicro.com'
agent[:activation_port]     = '443'

agent[:tenant_id]       = nil
agent[:tenant_password] = nil #should be in chef vault

agent[:policy_id]   = nil
agent[:policy_name] = nil