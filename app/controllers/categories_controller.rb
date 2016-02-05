class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    unless params[:utf8]
      @adverts = @category.adverts
    else
      @adverts = Advert.search do
        with :list_item_ids, params[:search][:list_items]
      end.results
    end

    # breadcrumbs NOTE: Почистить и поправить
    @parent = @category.parent
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
