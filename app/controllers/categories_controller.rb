# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#

class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    unless params[:utf8]
      @adverts = @category.adverts
    else
      @adverts = Advert.search do
        #with :list_item_ids, params[:search][:list_items]
      end.results
    end

    # breadcrumbs NOTE: Почистить и поправить
    @parent = @category.parent
    bread = []
    while @parent.present?
      bread << @parent
      @parent = @parent.parent
    end

    add_breadcrumb 'Корень', root_path
    bread.reverse!.each do |b|
      add_breadcrumb b, category_path(b)
    end
  end
end
