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
  include Breadcrumbs
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    unless params[:utf8]
      @adverts = @category.adverts
    else
      @adverts = Advert.search do
        with :list_item_ids, params[:search][:list_items]
      end.results
    end

    breadcrumbs_create(@category.parent)
    add_breadcrumb @category, category_path(@category)
  end
end
