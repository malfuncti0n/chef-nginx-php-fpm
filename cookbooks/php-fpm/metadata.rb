name             'php-fpm'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures fpm'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "apt"
depends "yum"

%w{ debian ubuntu centos redhat fedora amazon }.each do |os|
  supports os
end


