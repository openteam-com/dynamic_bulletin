class Attribute < ActiveRecord::Base
end

# == Schema Information
#
# Table name: attributes
#
#  id          :integer          not null, primary key
#  type        :string
#  name        :string
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
