class Metadata::CategoryPropertiesController < ApplicationController
  before_action :find_category
  before_action :find_category_property, only: [:edit]
  def new
    @caregory_property = CategoryProperty.create(:category_id => params[:category_id], :property_id => params[:property_id],
                            :necessarily => params[:necessarily],
                            :show_as => params[:show_as],
                            :show_on_public => params[:show_on_public],
                            :show_on_filter_as => params[:show_on_filter_as])
    redirect_to metadata_category_path(@category)
  end

  def edit
     @category_property.update(:category_id => params[:category_id], :property_id => params[:property_id],
                            :necessarily => params[:necessarily],
                            :show_as => params[:show_as],
                            :show_on_public => params[:show_on_public],
                            :show_on_filter_as => params[:show_on_filter_as])
    redirect_to metadata_category_path(@category)

  end

  def find_category_property
    @category_property = CategoryProperty.find(params[:id])
  end

  def find_category
    @category = Category.find(params[:category_id])
  end
end
