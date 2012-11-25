class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    render '/vdf/work-in-progress', status: 403
  end

  def not_found
    raise ActionController::RoutingError.new('Page introuvable')
  end
end
