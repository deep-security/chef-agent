A collection of recipes to help deploy and manage the Trend Micro Deep Security Agent.

## Requirements

All of the recipes in this cookbook require a working Deep Security infrastructure. The key component is the Trend Micro Deep Security Manager. The agents (which these recipes help you manage) do the heavy lifting but the manager gives the marching orders. 

There are no specific technical requirements beyond a standard Chef deployment.


## Attributes

#### Recipe : deep-security-agent::default

The "default" recipe runs the "deep-security-agent::dsa-install" and "deep-security-agent::dsa-activate" recipes internally.

Key | Type | Description | Default
----|------|-------------|--------
['dsm_agent_download_hostname'] | String | Hostname of the Deep Security Manager. | app.deepsecurity.trendmicro.com
['dsm_agent_download_port'] | Int | The port to connect to the Deep Security Manager to download the agents. This is typically the same port as the one used to access the Deep Security Manager admin interface. | 443
['ignore_ssl_validation'] | Boolean |  Whether or not to ignore the SSL certificate validation for agent downloads. Marketplace and software deployments ship with self-signed certificates and require this set to 'true'. | false
['dsm_agent_activation_hostname'] | String | The hostname for the agents to communicate with once deployed. For Marketplace and software deployments this is typically the same hostname as 'dsm_agent_download_hostname'. | agents.deepsecurity.trendmicro.com
['dsm_agent_activation_port'] | Int | The port to use for the agent heartbeat (the regular communication). For Marketplace and software deployments, the default is 4120. | 443
['tenant_id'] | String | In a multi-tenant installation (like Deep Security as a Service), this identifies the tenant account to register the agent with. | nil
['token'] | String | In a multi-tenant installation (like Trend Micro Deep Security as a Service), this identifies the tenant account to register the agent with. | nil
['policy_id'] | String | The Deep Security ID assigned to the policy to apply to the agents on activation. | nil
['force_reactivation'] | Boolean | Whether to force re-activation even Deep Security Agent has been activated. | false


#### Recipe : deep-security-agent::dsa-install

"dsa-install" recipe will download and install the Deep Security Agent service. Installation will be skipped if agent with same version already installed. If downloaded Deep Security Installer version is newer, then version upgrade will be performed.

Key | Type | Description | Default
----|------|-------------|--------
['dsm_agent_download_hostname'] | String | Hostname of the Deep Security Manager. | app.deepsecurity.trendmicro.com
['dsm_agent_download_port'] | Int | The port to connect to the Deep Security Manager to download the agents. This is typically the same port as the one used to access the Deep Security Manager admin interface. | 443
['ignore_ssl_validation'] | Boolean |  Whether or not to ignore the SSL certificate validation for agent downloads. Marketplace and software deployments ship with self-signed certificates and require this set to 'true'. | false


#### Recipe : deep-security-agent::dsa-activate

"dsa-activate" recipe will activate the Deep Security Agent service by registering into Trend Micro Deep Security Manager. By default, this recipe will skip activation if agent already in activated state, unless 'force_reactivation' attribute is set to 'true'.

Key | Type | Description | Default
----|------|-------------|--------
['dsm_agent_activation_hostname'] | String | The hostname for the agents to communicate with once deployed. For Marketplace and software deployments this is typically the same hostname as 'dsm_agent_download_hostname'. | agents.deepsecurity.trendmicro.com
['dsm_agent_activation_port'] | Int | The port to use for the agent heartbeat (the regular communication). For Marketplace and software deployments, the default is 4120. | 443
['tenant_id'] | String | In a multi-tenant installation (like Deep Security as a Service), this identifies the tenant account to register the agent with. | nil
['token'] | String | In a multi-tenant installation (like Trend Micro Deep Security as a Service), this identifies the tenant account to register the agent with. | nil
['policy_id'] | String | The Deep Security ID assigned to the policy to apply to the agents on activation. | nil
['force_reactivation'] | Boolean | Whether to force re-activation even Deep Security Agent has been activated. | false

## Usage

#### Recipe : deep-security-agent::default

Make sure that you include 'deep-security-agent' in your node's 'run_list'. This ensures that the Deep Security Agent is installed (it's the default.rb recipe).

```json
{
  "name":"my_node",
  "default_attributes": {
    "deep_security_agent" : {
      "dsm_agent_download_hostname": "app.deepsecurity.trendmicro.com",
      "dsm_agent_download_port" : "443",
      "dsm_agent_activation_hostname" : "agents.deepsecurity.trendmicro.com",
      "dsm_agent_activation_port" : "443",
      "tenant_id" : "<Deep Security DSAAS Tenant ID>",
      "token" : "<Deep Security DSAAS Tenant Token>"
	}
  },
  "run_list": [
    "recipe[deep-security-agent::default]"
  ]
}
```

## Acknowledgment

* We thank [Blair Hamilton](https://github.com/blairham) for his contributions to the [Deep Security Agent cookbook] (https://supermarket.chef.io/cookbooks/deep-security-agent).