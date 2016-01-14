class Category < ActiveRecord::Base
  has_many :adverts
  has_many :properties

  alias_attribute :to_s, :title
end

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
