#
# Cookbook Name:: deep-security-agent
# Recipe:: Build an integrity baseline for the node
#
# Copyright 2015, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Create an integrity baseline for the current node
# *********************************************************************

args = "--buildBaseline" # create an integrity baseline and send it to the manager

Chef::Log.info "The Deep Security agent will check in with the manager shortly"

dsa_control(args, 'create_integrity')