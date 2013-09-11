class McollectiveController < ApplicationController
  before_filter :find_smart_proxy, :only => [:submit_install_packages, :submit_uninstall_packages, :submit_restart_services, :submit_start_services, :submit_stop_services]
  before_filter :package_name, :only => [:submit_install_packages, :submit_uninstall_packages]
  before_filter :service_name, :only => [:submit_start_services, :submit_restart_services, :submit_restart_services]

  def install_packages
  end

  def submit_install_packages
    response = ProxyAPI::MCollective.new({:url => @mc_proxy.url}).install_package(@package_name)

    # TODO handle partial successes/failures
    if response[0]["statuscode"] == 0
      process_success :success_redirect => hosts_path(), :success_msg => _("successfully installed package %s") % @package_name
    else
      process_error :redirect => hosts_path(), :error_msg => _("failed to install package '%s': %s") % [@package_name, response[0]["statusmsg"]]
    end
  rescue => e
    process_error :redirect => hosts_path(), :error_msg => _("failed to install a package: %s") % e
  end

  def uninstall_packages
  end

  def submit_uninstall_packages
    response = ProxyAPI::MCollective.new({:url => @mc_proxy.url}).delete_package(@package_name)

    if response[0]["statuscode"] == 0
      process_success :success_redirect => hosts_path(), :success_msg => _("successfully uninstalled package %s") % @package_name
    else
      process_error :redirect => hosts_path(), :error_msg => _("failed to uninstall package '%s': %s") % [@package_name, response[0]["statusmsg"]]
    end
  rescue => e
    process_error :redirect => hosts_path(), :error_msg => _("failed to uninstall a package: %s") % e
  end

  def submit_start_services
  response = ProxyAPI::MCollective.new({ :url => @mc_proxy.url}).start_service(@service_name)
  if response[0]["statuscode"] == 0
    process_success :success_redirect => hosts_path(), :success_msg => _("successfully started service %s") % @service_name
  else
    process_error :redirect => hosts_path(), :error_msg => _("failed to start service: '%s': %s") % [@service_name, response[0]["statusmsg"]]
  end
  rescue => e
    process_error :redirect => hosts_path(), :error_msg => _("failed to start services: %s") % e
  end

  def submit_stop_services
  response = ProxyAPI::MCollective.new({ :url => @mc_proxy.url}).stop_service(@service_name)
  if response[0]["statuscode"] == 0
    process_success :success_redirect => hosts_path(), :success_msg => _("successfully stoped service %s") % @service_name
  else
    process_error :redirect => hosts_path(), :error_msg => _("failed to stop service: '%s': %s") % [@service_name, response[0]["statusmsg"]]
  end
  rescue => e
    process_error :redirect => hosts_path(), :error_msg => _("failed to stop services: %s") % e
  end

  def submit_restart_services
  response = ProxyAPI::MCollective.new({ :url => @mc_proxy.url}).restart_service(@service_name)
  if response[0]["statuscode"] == 0
    process_success :success_redirect => hosts_path(), :success_msg => _("successfully restarted service %s") % @service_name
  else
    process_error :redirect => hosts_path(), :error_msg => _("failed to restart service: '%s': %s") % [@service_name, response[0]["statusmsg"]]
  end
  rescue => e
    process_error :redirect => hosts_path(), :error_msg => _("failed to restart services: %s") % e
  end

  def find_smart_proxy
    @mc_proxy = SmartProxy.joins(:features).where("features.name" => "MCollective").first
    return process_error :redirect => :back, :error_msg => _("There are no configured mcollective proxies") unless @mc_proxy
  end

  def package_name
    @package_name = params[:package][:name]
  end

  def service_name
   @service_name = params[:service][:name]
  end
end
