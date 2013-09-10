class McollectiveController < ApplicationController
  def install_packages
  end

  def submit_install_packages
    mc_proxy = SmartProxy.joins(:features).where("features.name" => "MCollective").first
    if true #mc_proxy
      ProxyAPI::Mcollective.new({:url => "http://localhost"}).install_package(params[:package][:name])
    else
      process_error :redirect => :back, :error_msg => _("There are no configured mcollective proxies")
    end
    process_success :success_redirect => hosts_path(), :success_msg => _("successfully installed package")
  rescue => e
    process_error :redirect => hosts_path(), :error_msg => _("failed to install a package: %s") % e
  end
end
