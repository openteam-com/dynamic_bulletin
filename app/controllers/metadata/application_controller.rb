class Metadata::ApplicationController < ApplicationController
  load_and_authorize_resource
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  layout 'metadata'

  def current_ability
    Ability.new(current_user, :metadata)
  end
end
