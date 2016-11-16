#
# Cookbook Name:: deep-security-agent
# Recipe:: Check-in with the Deep Security manager
#
# Copyright 2015, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Ask the Deep Security agent to check-in
# *********************************************************************

args = "-m" # force a heartbeat with the manager

Chef::Log.info "The Deep Security agent will check in with the manager shortly"

dsa_control(args, 'check_in')