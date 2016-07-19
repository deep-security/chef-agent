# Recipes

<dl>

<dt>[default.rb](default.rb)</dt>

<dd>Deploys the Deep Security agent to the node<sup>1</sup></dd>

<dt>[dsa-check-in-with-manager.rb](dsa-check-in-with-manager.rb)</dt>

<dd>Asks the Deep Security agent to check in with the Deep Security manager (forced heartbeat</dd>

<dt>[dsa-create-diagnostic-package.rb](dsa-create-diagnostic-package.rb)</dt>

<dd>Creates a diagnostic package for the agent and send it to the Deep Security manager</dd>

<dt>[dsa-create-integrity-baseline.rb](dsa-create-integrity-baseline.rb)</dt>

<dd>Create a baseline for the integrity monitoring engine</dd>

<dt>[dsa-recommend-security-policy.rb](dsa-recommend-security-policy.rb)</dt>

<dd>Scans the node and recommends a security policy based on the current profile of the node</dd>

<dt>[dsa-scan-for-integrity-changes.rb](dsa-scan-for-integrity-changes.rb)</dt>

<dd>Scans the node for changes to the filesystem and memory based on the rules running in the integrity monitoring engine</dd>

<dt>[dsa-scan-for-malware.rb](dsa-scan-for-malware.rb)</dt>

<dd>Scans the node for malware</dd>

</dl>

<sup>1</sup> Only the [default.rb](default.rb) recipe requires any data to be passed. These requirements are outlined in the [/deep-security-agent/README.md#attributes](../README.md#attributes) section of the main README. All other recipes run without any additional attributes.