class CategoriesController < ApplicationController
  include Breadcrumbs

  def index
    @categories = Category.roots
  end

  def show
    #raise params.inspect
    @category = Category.find(params[:id])
    @adverts = Searchers::AdvertsSearcher.new(adverts_search_params).collection

    initialize_breadcrumbs
  end

  def initialize_breadcrumbs
    breadcrumbs_create(@category)
    add_breadcrumb  @category
  end

  private
  def adverts_search_params
    {
      list_items: params[:search].try(:[], :list_items),
      hierarch_list_items: params[:search].try(:[], :hierarch_list_items)
    }
  end
end
