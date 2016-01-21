require 'rails_helper'

RSpec.describe Advert, type: :model do
  it 'shoud create new advert' do
    advert = Advert.create

    expect(advert).to eq(Advert.last)
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
