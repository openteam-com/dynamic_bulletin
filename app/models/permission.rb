class Permission < ActiveRecord::Base
  belongs_to :user

  extend Enumerize
  enumerize :role, in: [:admin, :manager], prefix: true
end
