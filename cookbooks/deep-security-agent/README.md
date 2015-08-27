deep-security-agent Cookbook
============================
A collection of recipes to help deploy and manage the Deep Security agent.

## Requirements

All of the recipes in this cookbook require a working Deep Security infrastructure. The key component is the Deep Security manager. The agents (which these recipes help you manager) do the heavy lifting but the manager gives the marching orders. 

There are no specific technical requirements beyond a standard Chef deployment.

## Attributes

#### deep-security-agent::deploy-dsa
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['dsm_agent_download_hostname']</tt></td>
    <td>String</td>
    <td>Hostname of the Deep Security manager</td>
    <td><tt>app.deepsecurity.trendmicro.com</tt></td>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['dsm_agent_download_port']</tt></td>
    <td>Int</td>
    <td>The port to connect to the Deep Security manager on to download the agents. This is typically the same port as the admin web access</td>
    <td><tt>443</tt></td>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['ignore_ssl_validation']</tt></td>
    <td>Boolean</td>
    <td>Whether or not to ignore the SSL certificate validation for agent downloads. Marketplace AMI and software deployments ship with self-signed certificates and require this set to 'true'</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['dsm_agent_activation_hostname']</tt></td>
    <td>String</td>
    <td>The hostname for the agents to communicate with once deployed. For Marketplace AMI and software deployments this is typically the same hostname as 'dsm_agent_download_hostname'</td>
    <td><tt>agents.deepsecurity.trendmicro.com</tt></td>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['dsm_agent_activation_port']</tt></td>
    <td>Int</td>
    <td>The post to use for the agent heartbeat (the regular communication). For Marketplace AMI and software deployments, the default is 4118</td>
    <td><tt>443</tt></td>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['tenant_id']</tt></td>
    <td>String</td>
    <td>In a multi-tenant installation (like Deep Security as a Service), this identifies the tenant account to register the agent with</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['tenant_password']</tt></td>
    <td>String</td>
    <td>In a multi-tenant installation (like Deep Security as a Service), this identifies the tenant account to register the agent with</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['policy_id']</tt></td>
    <td>String</td>
    <td>The Deep Security ID assigned to the policy to apply to the agents on activation</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['policy_name']</tt></td>
    <td>String</td>
    <td>The name you assigned to the policy to apply to the agents on activation</td>
    <td><tt>nil</tt></td>
  </tr>
</table>

## Usage

#### deep-security-agent::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `deep-security-agent` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[deep-security-agent]"
  ]
}
```

## Contributing

We're always open to PRs from the community. To submit one:

1. Fork the repo
1. Create a new feature branch
1. Make your changes
1. Submit a PR with an explanation of what/why/cavaets/etc.

We'll review and work with you to make sure that the fix gets pushed out quickly.