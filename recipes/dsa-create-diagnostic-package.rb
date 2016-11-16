#
# Cookbook Name:: deep-security-agent
# Recipe:: Collect a diagnostic package for the Deep Security agent
#
# Copyright 2015, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Ask the Deep Security agent to create a diagnostic package
# *********************************************************************

args = "-d" # create a diagnostic package and send it to the manager

Chef::Log.info "The Deep Security agent will check in with the manager shortly"

dsa_control(args, 'create_diagnostic')