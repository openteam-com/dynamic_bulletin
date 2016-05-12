# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ancestry        :string
#  ancestry_depth  :integer          default(0)
#  connect_with_id :integer
#

class CategoriesController < ApplicationController
  include Breadcrumbs

  def index
    @categories = Category.roots
  end

  def show
    @category = Category.find(params[:id])
    @adverts = Searchers::AdvertsSearcher.new(adverts_search_params).collection

    initialize_breadcrumbs
  end

  def initialize_breadcrumbs
    breadcrumbs_create(@category)
    add_breadcrumb  @category
  end

  def get_hierarch_children
    if request.xhr?
      array = []
      HierarchListItem.find(params[:parent_id]).children.each do |child|
        h = {}
        h[:id] = child.id
        h[:title] = child.title

        array << h
      end
      render text: array.to_json and return
    end
  end

  private
  def adverts_search_params
    {
      list_items: params.try(:[], :list_items),
      hierarch_list_items: params.try(:[], :hierarch_list_items),
      category_id: @category.id,
      page: params[:page]
    }
  end
end
