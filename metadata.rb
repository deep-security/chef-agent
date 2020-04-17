name             'workload-security-agent'
maintainer       'Trend Micro'
maintainer_email 'deepsecurityopensource@trendmicro.com'
license          'Apache-2.0'
description      'Installs/Configures the Workload Security Agent'
version          '2.0.1'

%w( amazon centos debian fedora oracle redhat ubuntu ).each do |os|
  supports os
end

source_url 'https://github.com/deep-security/chef-agent'
issues_url 'https://github.com/deep-security/chef-agent/issues'
chef_version '>= 12.18'

depends 'aws', '>= 8.2.0'
