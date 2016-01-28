require 'rails_helper'

RSpec.describe Advert, type: :model do
  it 'should generate empty values for new advert across categories' do
    parent_category = create :category, :with_properties, :with_children
    category = parent_category.children.first.children.first
    advert = category.adverts.new

    expect(advert.values.size).to eq(category.path.map(&:properties).map(&:count).sum)
  end

  it 'should`t return values unless category empty' do
    advert = Advert.new

    expect(advert.values.size).to eq(0)
  end
end

# == Schema Information
#
# Table name: adverts
#
#  id          :integer          not null, primary key
#  description :text
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
