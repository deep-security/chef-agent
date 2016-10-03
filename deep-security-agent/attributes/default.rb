#
# Author:: Blair Hamilton (bhamilton@draftkings.com)
# Cookbook Name:: deep-security-agent
# Attribute:: default
#
# Copyright:: Copyright (c) 2016, DraftKings Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# As you add agents to Deep Security, they are automatically made available for download through
#   the same hostname:port as the admin interface. For Marketplace AMI and software deployments, pass
#   this data through the 'dsm_agent_download_hostname' & 'dsm_agent_download_port' attributes
default['dsm_agent']['download_hostname'] = 'app.deepsecurity.trendmicro.com'
default['dsm_agent']['download_port'] = 443

# For Marketplace AMI and software deployments 'ignore_ssl_validation' must to set to 'true' 
#    unless you've installed a verifiable SSL certificate
default['dsm_agent']['ignore_ssl_validation'] = false

# Deep Security agents activate on a different port then the admin interface. For Marketplace AMI and
#    software deployments, 'dsm_agent_activation_hostname' is typically the same as 'dsm_agent_download_hostname'
#    but 'dsm_agent_activation_port' will be different then 'dsm_agent_download_port'. For Deep Security
#    as a Service, it's the reverse to make it easy to configure only one outbound port
default['dsm_agent']['activation_hostname'] = 'agents.deepsecurity.trendmicro.com'
default['dsm_agent']['activation_port'] = 443

# For multi-tenant deployments of Deep Security (such as Deep Security as a Service), every tenant/organization
#    is assigned a unique 'tenant_id' and 'tenant_password' that is only used for agent activation. You can
#    find this info from the Support/Help > Deployment Scripts menu option in the admin. Select any agent
#    and then check "Activate Agent automatically after installation". This will put the tenant_id and 
#    tenant_password in the script the wizard is building for you
default['dsm_agent']['tenant_id'] = nil
default['dsm_agent']['tenant_password'] = nil

# The ID of the policy you want to initialize the agent with. This takes precedence over the 
#    'policy_name' setting. 
default['dsm_agent']['policy_id'] = nil
# The name of the policy you want to initialize the agent with. This needs to be an exact string 
#    match in order to be applied. policy_id is a little more robust option (as you can change 
#    the name anytime you want) but you need to do a little more work to get the ID of the policy
default['dsm_agent']['policy_name'] = nil
