class My::ApplicationController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def current_ability
    Ability.new(current_user, :my)
  end
end
