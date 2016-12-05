# Chef

A cookbook of Chef recipes for the Deep Security agent. This allows for the easy deployment of the Deep Security agent as well as taking some common actions from the agent.


## Requirements

All of the recipes in this cookbook require a working Deep Security infrastructure. The key component is the Deep Security manager. The agents (which these recipes help you manage) do the heavy lifting but the manager gives the marching orders. 

There are no specific technical requirements beyond a standard Chef deployment.

## Support

This is a community project and while you will see contributions from the Deep Security team, there is no official Trend Micro support for this project. The official documentation for the Deep Security APIs is available from the [Trend Micro Online Help Centre](http://docs.trendmicro.com/en-us/enterprise/deep-security.aspx). 

Tutorials, feature-specific help, and other information about Deep Security is available from the [Deep Security Help Center](https://help.deepsecurity.trendmicro.com/Welcome.html). 

For Deep Security specific issues, please use the regular Trend Micro support channels. For issues with the code in this repository, please [open an issue here on GitHub](https://github.com/deep-security/chef/issues).

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
    <td><tt>['deep-security-agent']['download']['host']</tt></td>
    <td>String</td>
    <td>Hostname of the Deep Security manager</td>
    <td><tt>app.deepsecurity.trendmicro.com</tt></td>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['download']['port']</tt></td>
    <td>Int</td>
    <td>The port to connect to the Deep Security manager on to download the agents. This is typically the same port as the admin web access</td>
    <td><tt>443</tt></td>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['download']['ignore_ssl']</tt></td>
    <td>Boolean</td>
    <td>Whether or not to ignore the SSL certificate validation for agent downloads. Marketplace AMI and software deployments ship with self-signed certificates and require this set to 'true'</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['activation']['host']</tt></td>
    <td>String</td>
    <td>The hostname for the agents to communicate with once deployed. For Marketplace AMI and software deployments this is typically the same hostname as 'dsm_agent_download_hostname'</td>
    <td><tt>agents.deepsecurity.trendmicro.com</tt></td>
  </tr>
  <tr>
    <td><tt>['deep-security-agent']['activation']['port']</tt></td>
    <td>Int</td>
    <td>The post to use for the agent heartbeat (the regular communication). For Marketplace AMI and software deployments, the default is 4118</td>
    <td><tt>443</tt></td>
  </tr>
  <tr>
      <td><tt>['deep-security-agent']['activation']['sethost']</tt></td>
      <td>string</td>
      <td>If not nil the hostname set upon activation. default is nil</td>
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

Make sure that you include 'deep-security-agent' in your node's 'run_list'. This will ensure that the Deep Security agent is installed (it's the default.rb recipe).

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[deep-security-agent]"
  ]
}
```


## Recipes

<dl>
	<dt><a href="default.rb">default.rb</a></dt>
	<dd>Deploys the Deep Security agent to the node<sup>1</sup></dd>

	<dt><a href="dsa-check-in-with-manager.rb">dsa-check-in-with-manager.rb</a></dt>
	<dd>Asks the Deep Security agent to check in with the Deep Security manager (forced heartbeat</a></dd>

	<dt><a href="dsa-create-diagnostic-package.rb">dsa-create-diagnostic-package.rb</a></dt>
	<dd>Creates a diagnostic package for the agent and send it to the Deep Security manager</dd>

	<dt><a href="dsa-create-integrity-baseline.rb">dsa-create-integrity-baseline.rb</a></dt>
	<dd>Create a baseline for the integrity monitoring engine</dd>

	<dt><a href="dsa-recommend-security-policy.rb">dsa-recommend-security-policy.rb</a></dt>
	<dd>Scans the node and recommends a security policy based on the current profile of the node</dd>

	<dt><a href="dsa-scan-for-integrity-changes.rb">dsa-scan-for-integrity-changes.rb</a></dt>
	<dd>Scans the node for changes to the filesystem and memory based on the rules running in the integrity monitoring engine</dd>

	<dt><a href="dsa-scan-for-malware.rb">dsa-scan-for-malware.rb</a></dt>
	<dd>Scans the node for malware</dd>
</dl>

<sup>1</sup> Only the [default.rb](default.rb) recipe requires any data to be passed. These requirements are outlined in the [/deep-security-agent/README.md#attributes](../README.md#attributes) section of the main README. All other recipes run without any additional attributes.


## OpsWorks

This repository is also setup for use from [AWS OpsWorks](https://aws.amazon.com/opsworks/). You can enable this as a *custom cookbook* within your stack. This makes is very easy to ensure that the Deep Security agent is running on all of the EC2 instances within your stack.

To enable a custom cookbook:

1. From within your stack, click the "Stack Settings" button
1. On the stack setting page, click the blue "Edit" button
1. Slide the "Use custom Chef cookbooks" toggle to "Yes"
1. Set the follow:
	- "Repository type": *git*
	- "Repository URL": *https://github.com/deep-security/chef.git*
1. Click the blue "Save" button
1. On the "Deployments" page for your stack, click the gray "Run Command" button

If you have existing instances running, do the following;

1. Select "Update Custom Cookbooks" from the "Command" drop-down
1. Click the blue, "Update Custom Cookbooks" button to run the command

In the Layers section of the OpsWorks Management Console, for your layer;

1. Click Recipes
1. Under "Custom Recipes", in the "*Configuration*" life cycle enter **deep-security-agent::default**
1. Click the General Settings section
1. In the "Custom JSON" section, enter the necessary recipe settings

The recipe settings will be along the lines of;

```javascript
{
  "tenant_id": "11111111-2222-3333-4444-555555555555",
  "policy_name": "Policy Name",
  "tenant_password": "11111111-2222-3333-4444-555555555555"
}
```

The recipes within this repo are now available to you from within your AWS OpsWorks stack.

### Multiple custom cookbooks

**--This technique is still being tested--**

Since AWS OpsWorks only allows one custom cookbook per stack. You have to do a little extra work if you want to incorporate multiple custom cookbooks. Thankfully, git makes this easy. 

1. Create a new repo that you will use as your custom cookbook
1. Add each cookbook you want to use as a [```git submodule```](http://git-scm.com/docs/git-submodule)
1. Create a symbolic link to the recipe at the top level of the new repo (```ln -s clone/recipe recipe```)

This will keep each of the customer cookbook in it's own git repo but allow you to point OpsWorks to one place.

## Contributing

We're always open to PRs from the community. To submit one:

1. Fork the repo
1. Create a new feature branch
1. Make your changes
1. Submit a PR with an explanation of what/why/cavaets/etc.

We'll review and work with you to make sure that the fix gets pushed out quickly.