# Recipes

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

<sup>1</sup>Only the <a href="default.rb">default.rb</a> recipe requires any data to be passed. These requirements are outlined in the <a href="Attributes">/deep-security-agent/README.md#attributes</a> section of the main README. All other recipes run without any adtitional attributes.