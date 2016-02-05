class AdvertsController < ApplicationController
  def index
    @adverts = Advert.all
    @categories = Category.all
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
