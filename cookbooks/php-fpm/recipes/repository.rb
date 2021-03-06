case node['platform']
when 'ubuntu'
  if node['platform_version'].to_f <= 10.04
    # Configure Brian's PPA
    # We'll install php5-fpm from the Brian's PPA backports
    apt_repository "brianmercer-php" do
      uri "http://ppa.launchpad.net/brianmercer/php/ubuntu"
      distribution node['lsb']['codename']
      components ["main"]
      keyserver "keyserver.ubuntu.com"
      key "8D0DC64F"
      action :add
    end
    # FIXME: apt-get update didn't trigger in above
    execute "apt-get update"
  end
when 'debian'
  # Configure Dotdeb repos
  # TODO: move this to it's own 'dotdeb' cookbook?
  # http://www.dotdeb.org/instructions/
  if node['platform_version'].to_f >= 8.0
    apt_repository "dotdeb" do
      uri node['php-fpm']['dotdeb_repository']['uri']
      distribution "jessie"
      components ['all']
      key node['php-fpm']['dotdeb_repository']['key']
      action :add
    end
  elsif node['platform_version'].to_f >= 7.0
    apt_repository "dotdeb" do
      uri node['php-fpm']['dotdeb_repository']['uri']
      distribution "wheezy"
      components ['all']
      key node['php-fpm']['dotdeb_repository']['key']
      action :add
    end
  elsif node['platform_version'].to_f >= 6.0
    apt_repository "dotdeb" do
      uri node['php-fpm']['dotdeb_repository']['uri']
      distribution "squeeze"
      components ['all']
      key node['php-fpm']['dotdeb_repository']['key']
      action :add
    end
  else
    apt_repository "dotdeb" do
      uri node['php-fpm']['dotdeb_repository']['uri']
      distribution "oldstable"
      components ['all']
      key node['php-fpm']['dotdeb_repository']['key']
      action :add
    end
    apt_repository "dotdeb-php53" do
      uri node['php-fpm']['dotdeb-php53_repository']['uri']
      distribution "oldstable"
      components ['all']
      key node['php-fpm']['dotdeb_repository']['key']
      action :add
    end
  end

when 'amazon', 'fedora', 'centos', 'redhat'
  unless platform?('centos', 'redhat') && node['platform_version'].to_f >= 6.4
    yum_repository 'remi' do
      description 'Remi'
      url node['php-fpm']['yum_url']
      mirrorlist node['php-fpm']['yum_mirrorlist']
      gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
      action :add
    end
  end
end
