# Chef

A cookbook of Chef recipes for the Deep Security agent. This allows for the easy deployment of the Deep Security agent as well as taking some common actions from the agent.

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
1. Select "Update Custom Cookbooks" from the "Command" drop-down
1. Click the blue, "Update Custom Cookbooks" button to run the command

The recipes within this repo are now available to you from within your AWS OpsWorks stack.