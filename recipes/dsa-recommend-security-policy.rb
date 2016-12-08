#
# Cookbook Name:: deep-security-agent
# Recipe:: Recommend a security policy for the node
#
# Copyright 2015, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Recommend a security policy for the node
# *********************************************************************

args = "-m \"RecommendationScan:true\"" # create an integrity baseline and send it to the manager

Chef::Log.info "The Deep Security agent will check in with the manager shortly"

dsa_control(args, 'recommend')