require 'rails_helper'

RSpec.describe CategoryProperty, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: category_properties
#
#  id                :integer          not null, primary key
#  category_id       :integer
#  property_id       :integer
#  created_at        :datetime
#  updated_at        :datetime
#  show_on_public    :boolean          default(TRUE)
#  necessarily       :boolean          default(FALSE)
#  show_as           :string           default("check_boxes")
#  row_order         :integer
#  show_on_filter_as :string
#
