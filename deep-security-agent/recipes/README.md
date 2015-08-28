# Recipes

- [default.rb](default.rb) : Deploys the Deep Security agent to the node
- [dsa-check-in-with-manager.rb](dsa-check-in-with-manager.rb) : Asks the Deep Security agent to check in with the Deep Security manager (forced heartbeat)
- [dsa-create-diagnostic-package.rb](dsa-create-diagnostic-package.rb) : Creates a diagnostic package for the agent and send it to the Deep Security manager
- [dsa-create-integrity-baseline.rb](dsa-create-integrity-baseline.rb) : Create a baseline for the integrity monitoring engine
- [dsa-recommend-security-policy.rb](dsa-recommend-security-policy.rb) : Scans the node and recommends a security policy based on the current profile of the node
- [dsa-scan-for-integrity-changes.rb](dsa-scan-for-integrity-changes.rb) : Scans the node for changes to the filesystem and memory based on the rules running in the integrity monitoring engine
- [dsa-scan-for-malware.rb](dsa-scan-for-malware.rb) : Scans the node for malware

Only the [default.rb](default.rb) recipe requires any data to be passed. These requirements are outlined in the [Attributes](/deep-security-agent/README.md#attributes) section of the main README. All other recipes run without any additional attributes.