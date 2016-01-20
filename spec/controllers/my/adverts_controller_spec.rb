require 'rails_helper'

RSpec.describe My::AdvertsController, type: :controller do
  describe "GET #new" do
    it 'should return @advert eq to nil if category empty' do
      get :new

      expect(assigns(:advert)).not_to be_a_new(Advert)
    end

    it 'shoud return @advert eq to Advert.new if category present' do
      category = Category.create title: 'test'

      get :new, { category_id: category.id }

      expect(assigns(:advert)).to be_a_new(Advert)
    end

    it 'should find advert on show' do
      category = Category.create title: 'test'
      category.adverts.create! description: 'ololo'

      get :show, { id: Advert.last.id }

      expect(assigns(:advert)).to eq(Advert.last)
    end
  end
end
