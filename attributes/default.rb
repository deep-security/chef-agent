# deep-security-agent cookbook attributes

# ensure that chef-vault databag fallback is disabled by default
default['chef-vault']['databag_fallback'] = false

agent = default['deep-security-agent']

agent[:download][:host]       = 'app.deepsecurity.trendmicro.com'
agent[:download][:port]       = '443'
agent[:download][:ignore_ssl] = false

agent[:activation][:hostname] = 'agents.deepsecurity.trendmicro.com'
agent[:activation][:port]     = '443'
agent[:activation][:sethost]  = nil #hostname to set upon activation

agent[:tenant_id]       = nil
agent[:tenant_password] = nil #should be in chef vault

agent[:policy_id]   = nil
agent[:policy_name] = nil