name             'workload-security-agent'
maintainer       'Trend Micro'
maintainer_email 'deepsecurityopensource@trendmicro.com'
license          'All rights reserved'
description      'Installs/Configures the Workload Security Agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'aws', '>= 8.0.4'
