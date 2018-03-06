#
# Copyright 2018, Trend Micro
#
# License as per [repo](master/LICENSE)
#
# *********************************************************************
# * Utility for Deep Security Agent cookbook
# *********************************************************************

module DSA_Helpers
  BOOTSTRAP_CERT = 'D0:68:DE:48:1B:DC:4D:00:89:07:7F:85:15:20:C5:90:11:EB:56:6A'.freeze
  PACKAGE_RPM = 'ds_agent.rpm'.freeze
  PACKAGE_DEB = 'ds_agent.deb'.freeze
  PACKAGE_MSI = 'ds_agent.msi'.freeze

  class DSAPlatform
    attr_accessor :host_platform, :host_platform_version, :installer_file_name, :arch_type
  end

  def detect_DSA_host_platform
    currentDSAPlatform = DSAPlatform.new
    case node[:platform]
    when /amazon/
      currentDSAPlatform.host_platform = 'amzn'
      currentDSAPlatform.host_platform_version = '1'
      currentDSAPlatform.installer_file_name = PACKAGE_RPM
    when /redhat/, /centos/
      currentDSAPlatform.host_platform = 'RedHat_EL'
      currentDSAPlatform.host_platform_version = "#{/(\d+)/.match(node[:platform_version])[1]}"
      currentDSAPlatform.installer_file_name = PACKAGE_RPM
    when /suse/
      currentDSAPlatform.host_platform = 'SuSE_'
      currentDSAPlatform.host_platform_version = "#{/(\d+)/.match(node[:platform_version])[1]}"
      currentDSAPlatform.installer_file_name = PACKAGE_RPM
    when /debian/
      currentDSAPlatform.host_platform = 'Debian_'
      currentDSAPlatform.host_platform_version = "#{/(\d+)/.match(node[:platform_version])[1]}"
      currentDSAPlatform.installer_file_name = PACKAGE_DEB
    when /ubuntu/
      currentDSAPlatform.host_platform = 'Ubuntu_'
      currentDSAPlatform.host_platform_version = "#{/(\d+)/.match(node[:platform_version])[1]}.04"
      currentDSAPlatform.installer_file_name = PACKAGE_DEB
    when /windows/
      currentDSAPlatform.host_platform = 'Windows'
      currentDSAPlatform.host_platform_version = ''
      currentDSAPlatform.installer_file_name = PACKAGE_MSI
    when /oracle/, /enterpriseenterprise/
      currentDSAPlatform.host_platform = 'Oracle_OL'
      currentDSAPlatform.host_platform_version = "#{/(\d+)/.match(node[:platform_version])[1]}"
      currentDSAPlatform.installer_file_name = PACKAGE_RPM
    when /cloudlinux/
      currentDSAPlatform.host_platform = 'CloudLinux_'
      currentDSAPlatform.host_platform_version = "#{/(\d+)/.match(node[:platform_version])[1]}"
      currentDSAPlatform.installer_file_name = PACKAGE_RPM
    end

    # assume 64-bit but allow for 32-bit when detected
    currentDSAPlatform.arch_type = 'x86_64'
    if node['kernel']['machine'] =~ /32/
      currentDSAPlatform.arch_type = 'i386'
    end

    Chef::Log.info "Ohai reporting: #{node[:platform]}, #{node[:platform_version]}, #{node[:kernel][:machine]}"
	currentDSAPlatform
  end

  # run a dsa command
  def is_DSA_activated?

    Chef::Log.info "Check if DSA activated"

    activated = false
    dsa_query_command = ''
    dsa_query_parameter = '-c GetAgentStatus agentCertHash'
    if node[:platform_family] =~ /win/
      dsa_query_command = ENV['programfiles'] + '\\Trend Micro\\Deep Security Agent\\dsa_query.cmd'
    else
      dsa_query_command = '/opt/ds_agent/dsa_query'
    end

    for i in 0..5
      if File.exist?(dsa_query_command)
        break
      end
      Chef::Log.info "Retrying check #{dsa_query_command} availability"
      sleep 2
    end

    if !File.exist?(dsa_query_command)
      raise "Could not find command \"#{dsa_query_command}\" to query DSA certificate. Please make sure Deep Security Agent has been installed."
    end

    certHashRetry = 0
    certHash = nil
    while (certHash == nil || certHash == '') && certHashRetry < 5 do
      rawAgentCertHash = `"#{dsa_query_command}" #{dsa_query_parameter}`
      begin
        certHash = "#{/^AgentStatus.agentCertHash: ([0-9A-F:]+)$/i.match(rawAgentCertHash)[1]}"
      rescue => exception
        Chef::Log.warn "#{exception.message}"
      end

      if certHash == nil || certHash == ''
        Chef::Log.info "Retrying #{dsa_query_command} to be available"
        sleep 2
      end
    end

    if certHash == nil || certHash == ''
      raise "Could not query Deep Security Agent certificate. Please make sure Deep Security Agent has been installed."
    elsif !BOOTSTRAP_CERT.casecmp(certHash)
      activated = true
    else
      activated = false
    end

    Chef::Log.info "Check DSA activated returned : #{activated}"
    activated
  end



end

Chef::Recipe.send(:include, DSA_Helpers)
Chef::Resource::Execute.send(:include, DSA_Helpers)
Chef::Resource::PowershellScript.send(:include, DSA_Helpers)
