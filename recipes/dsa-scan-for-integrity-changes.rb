#
# Cookbook Name:: deep-security-agent
# Recipe:: Scan for changes to the nodes integrity
#
# Copyright 2015, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Scan for changes to the nodes integrity
# *********************************************************************

args = "--scanForChanges" # create an integrity baseline and send it to the manager

Chef::Log.info "The Deep Security agent will check in with the manager shortly"

dsa_control(args, 'scan_integrity')