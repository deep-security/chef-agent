# Recipes

<dl>
	<dt><a href="default.rb">default.rb</a></dt>
	<dd>Download, install and activate the Deep Security Agent to the node. This recipe calls [dsa-install.rb](dsa-install.rb) and [dsa-activate.rb](dsa-activate.rb) internally<sup>1</sup>.</dd>
	<dt><a href="dsa-install.rb">dsa-install.rb</a></dt>
	<dd>Download and install the Deep Security Agent service. Installation will be skipped if agent with same version already installed. If downloaded Deep Security Installer version is newer, then version upgrade will be performed<sup>1</sup>.</a></dd>
	<dt><a href="dsa-activate.rb">dsa-activate.rb</a></dt>
	<dd>Activate the Deep Security Agent service by registering into Trend Micro Deep Security Manager. By default, this recipe will skip activation if agent already in activated state, unless 'force_reactivation' attribute is set to 'true'<sup>1</sup>.</dd>
	<dt><a href="dsa-check-in-with-manager.rb">dsa-check-in-with-manager.rb</a></dt>
	<dd>Asks the Deep Security Agent to check in with the Deep Security Manager (forced heartbeat).</a></dd>
	<dt><a href="dsa-create-diagnostic-package.rb">dsa-create-diagnostic-package.rb</a></dt>
	<dd>Creates a diagnostic package for the agent and send it to the Deep Security Manager.</dd>
	<dt><a href="dsa-create-integrity-baseline.rb">dsa-create-integrity-baseline.rb</a></dt>
	<dd>Create a baseline for the integrity monitoring engine.</dd>
	<dt><a href="dsa-recommend-security-policy.rb">dsa-recommend-security-policy.rb</a></dt>
	<dd>Scans the node and recommends a security policy based on the current profile of the node.</dd>
	<dt><a href="dsa-scan-for-integrity-changes.rb">dsa-scan-for-integrity-changes.rb</a></dt>
	<dd>Scans the node for changes to the filesystem and memory based on the rules running in the integrity monitoring engine.</dd>
	<dt><a href="dsa-scan-for-malware.rb">dsa-scan-for-malware.rb</a></dt>
	<dd>Scans the node for malware.</dd>
</dl>

<sup>1</sup> These recipes requires any data to be passed. These requirements are outlined in the [/deep-security-agent/README.md#attributes](../README.md#attributes) section of the main README. All other recipes run without any additional attributes.