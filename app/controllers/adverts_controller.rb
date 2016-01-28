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

class AdvertsController < ApplicationController
  def index
    unless params[:utf8]
      @adverts = Advert.all
      @categories = Category.all
    else
      @adverts = Advert.all.take(2)
      @categories = Category.all.take(2)
    end
  end
end
