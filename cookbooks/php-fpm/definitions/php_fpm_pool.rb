
define :php_fpm_pool, :template => "pool.conf.erb", :enable => true do

  pool_name = params[:name]

  conf_file = "#{node['php-fpm']['pool_conf_dir']}/#{pool_name}.conf"

  if params[:enable]
    template conf_file do
      only_if "test -d #{node['php-fpm']['pool_conf_dir']} || mkdir -p #{node['php-fpm']['pool_conf_dir']}"
      source params[:template]
      owner "root"
      group "root"
      mode 00644
      cookbook params[:cookbook] || "php-fpm"
      variables(
        :pool_name => pool_name,
        :listen => params[:listen] || node['php-fpm']['listen'].gsub(%r[%{pool_name}], pool_name),
        :listen_owner => params[:listen_owner] || node['php-fpm']['listen_owner'] || node['php-fpm']['user'],
        :listen_group => params[:listen_group] || node['php-fpm']['listen_group'] || node['php-fpm']['group'],
        :listen_mode => params[:listen_mode] || node['php-fpm']['listen_mode'],
        :allowed_clients => params[:allowed_clients],
        :user => params[:user] || node['php-fpm']['user'],
        :group => params[:group] || node['php-fpm']['group'],
        :process_manager => params[:process_manager] || node['php-fpm']['process_manager'],
        :max_children => params[:max_children] || node['php-fpm']['max_children'],
        :start_servers => params[:start_servers] || node['php-fpm']['start_servers'],
        :min_spare_servers => params[:min_spare_servers] || node['php-fpm']['min_spare_servers'],
        :max_spare_servers => params[:max_spare_servers] || node['php-fpm']['max_spare_servers'],
        :max_requests => params[:max_requests] || node['php-fpm']['max_requests'],
        :catch_workers_output => params[:catch_workers_output] || node['php-fpm']['catch_workers_output'],
        :security_limit_extensions => params[:security_limit_extensions] || node['php-fpm']['security_limit_extensions'],
        :access_log => params[:access_log] || false,
        :slowlog => params[:slowlog] || false,
        :request_slowlog_timeout => params[:request_slowlog_timeout] || false,
        :php_options => params[:php_options] || {},
        :request_terminate_timeout => params[:request_terminate_timeout] || node['php-fpm']['request_terminate_timeout'],
        :params => params
      )
      notifies :restart, "service[php-fpm]"
    end
  else
    cookbook_file conf_file do
      action :delete
      notifies :restart, "service[php-fpm]"
    end
  end
end
