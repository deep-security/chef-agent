#
# Cookbook:: deep-security-agent-test
# Recipe:: default
#
# Copyright 2017, Trend Micro


# Disable required TTY session for sudo in RHEL and Centos
# "requiretty" will block Kitchen's Inspect from verifying VM status
if node[:platform] =~ /redhat/ or node[:platform] =~ /centos/
  execute 'Set !require tty for kitchen user' do
    action :run
    command 'echo "Defaults!ALL !requiretty" >> /etc/sudoers.d/kitchen'
    not_if 'grep "Defaults!ALL !requiretty" /etc/sudoers.d/kitchen'
  end
end
