class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
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
