class Metadata::HierarchListItemsController < ApplicationController
  before_action :find_category
  before_action :find_property
  before_action :find_hierarch_list_item, only: [:show, :edit, :update, :destroy]
  before_action :find_parent_item, only: [:create]

  def new
    if params[:parent_id]
      @hierarch_list_item = HierarchListItem.find(params[:parent_id]).children.new
    else
      @hierarch_list_item = HierarchListItem.new
    end
  end


  def create
    if params[:parent_id]
      @hierarch_list_item = @parent_item.children.create(hierarch_list_item_params)
    else
      @hierarch_list_item = HierarchListItem.create(hierarch_list_item_params)
    end
    respond_with @hierarch_list_item, location: -> { [:metadata, @category, @property, @hierarch_list_item.parent.present? ? @hierarch_list_item.parent : @hierarch_list_item]}
  end

  def find_category
    @category = Category.find(params[:category_id])
  end

  def find_property
    @property = Property.find(params[:property_id])
  end

  def find_parent_item
    if params[:parent_id]
      @parent_item = HierarchListItem.find(params[:parent_id])
    end
  end

  private
  def find_hierarch_list_item

    @hierarch_list_item = HierarchListItem.find(params[:id])
  end

  def hierarch_list_item_params
    params.require(:hierarch_list_item).permit(:title, :parent_id, :property_id)
  end

end
