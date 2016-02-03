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

  def show
    @advert = Advert.find(params[:id])
    @parent = @advert.category
    bread = []
    while @parent.present?
      bread << @parent
      @parent = @parent.parent
    end

    add_breadcrumb 'Корень', adverts_path
    bread.reverse!.each do |b|
      add_breadcrumb b, category_path(b)
    end


  end
end
