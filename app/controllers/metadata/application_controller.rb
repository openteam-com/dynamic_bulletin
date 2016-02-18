class Metadata::ApplicationController < ApplicationController
  load_and_authorize_resource

  protect_from_forgery with: :exception

  before_action :authenticate_user!

  layout 'metadata'

  def current_ability
    Ability.new(current_user, :metadata)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
