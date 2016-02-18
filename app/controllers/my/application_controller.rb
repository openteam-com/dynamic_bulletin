class My::ApplicationController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  layout 'my'

  def current_ability
    Ability.new(current_user, :my)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
