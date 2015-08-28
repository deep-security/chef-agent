# Recipes

<dl>
	<dd>[default.rb](default.rb)</dd>
	<dt>Deploys the Deep Security agent to the node</dt>

	<dd>[dsa-check-in-with-manager.rb](dsa-check-in-with-manager.rb)</dd>
	<dt>Asks the Deep Security agent to check in with the Deep Security manager (forced heartbeat)</dt>

	<dd>[dsa-create-diagnostic-package.rb](dsa-create-diagnostic-package.rb)</dd>
	<dt>Creates a diagnostic package for the agent and send it to the Deep Security manager</dt>

	<dd>[dsa-create-integrity-baseline.rb](dsa-create-integrity-baseline.rb)</dd>
	<dt>Create a baseline for the integrity monitoring engine</dt>

	<dd>[dsa-recommend-security-policy.rb](dsa-recommend-security-policy.rb)</dd>
	<dt>Scans the node and recommends a security policy based on the current profile of the node</dt>

	<dd>[dsa-scan-for-integrity-changes.rb](dsa-scan-for-integrity-changes.rb)</dd>
	<dt>Scans the node for changes to the filesystem and memory based on the rules running in the integrity monitoring engine</dt>

	<dd>[dsa-scan-for-malware.rb](dsa-scan-for-malware.rb)</dd>
	<dt>Scans the node for malware</dt>
</dl>

Only the [default.rb](default.rb) recipe requires any data to be passed. These requirements are outlined in the [Attributes](/deep-security-agent/README.md#attributes) section of the main README. All other recipes run without any additional attributes.