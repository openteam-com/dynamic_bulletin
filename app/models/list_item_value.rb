class ListItemValue < ActiveRecord::Base
  belongs_to :list_item
  belongs_to :value
end

# == Schema Information
#
# Table name: list_item_values
#
#  id           :integer          not null, primary key
#  list_item_id :integer
#  value_id     :integer
#
