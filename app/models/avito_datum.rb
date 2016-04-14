class AvitoDatum < ActiveRecord::Base
  serialize :data, Array
end

# == Schema Information
#
# Table name: avito_data
#
#  id                   :integer          not null, primary key
#  data                 :text
#  rest_app_category_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
