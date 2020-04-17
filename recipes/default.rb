#
## Cookbook Name:: workload-security-agent
## Recipe:: default
##
## Copyright 2020, Trend Micro
##
## License as per [repo](master/LICENSE)
##
## *********************************************************************
## * Run default recipe
## *********************************************************************

include_recipe 'workload-security-agent::get-api-secret-key'
include_recipe 'workload-security-agent::get-deployment-script'
include_recipe 'workload-security-agent::run-deployment-script'

