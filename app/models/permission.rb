class Permission < ActiveRecord::Base
  belongs_to :user

  extend Enumerize
  enumerize :role, in: [:admin, :manager], prefix: true
end

# == Schema Information
#
# Table name: permissions
#
#  id      :integer          not null, primary key
#  role    :string
#  user_id :integer
#
