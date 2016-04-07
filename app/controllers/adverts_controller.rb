class AdvertsController < ApplicationController
  include Breadcrumbs
  def show
    @advert = Advert.find(params[:id])
    initialize_breadcrumbs
  end

  def initialize_breadcrumbs
    breadcrumbs_create(@advert.category)
    add_breadcrumb @advert.category, category_path(@advert.category)
    add_breadcrumb @advert
  end
end
