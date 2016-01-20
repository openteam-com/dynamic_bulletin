require 'rails_helper'

RSpec.describe Advert, type: :model do
  it 'shoud create new advert' do
    advert = Advert.create

    expect(advert).to eq(Advert.last)
  end
end
