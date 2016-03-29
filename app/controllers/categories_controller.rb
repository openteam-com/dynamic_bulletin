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
      @adverts = @category.adverts.search do
        any_of do
          with :list_item_ids, params.try(:[], 'search').try(:[], 'list_items')
          with :hierarch_list_item_ids, params.try(:[], 'search').try(:[], 'hierarch_list_items')
        end
      end.results
    end

    initialize_breadcrumbs
  end

  def initialize_breadcrumbs
    breadcrumbs_create(@category)
    add_breadcrumb  @category
  end
end
