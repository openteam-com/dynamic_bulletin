class Metadata::ListItemsController < Metadata::ApplicationController
  before_action :find_category
  before_action :find_property
  before_action :find_list_item, only: [:show, :edit, :update, :destroy]
  before_action :find_parent_item
  before_action :init_list_item

  def new
    if params[:parent_id]
      @list_item = ListItem.find(params[:parent_id]).children.new
    else
      @list_item = ListItem.new
    end
  end

  def create
    if params[:parent_id]
      @list_item = @parent_item.children.create(list_item_params)
    else
      @list_item = ListItem.create(list_item_params)
    end
    respond_with @list_item, location: -> { [:metadata, @category, @property, @list_item.parent.present? ? @list_item.parent : @list_item]}
  end

  def find_category
    @category = Category.find(params[:category_id])
  end

  def find_property
    @property = Property.find(params[:property_id])
  end

  def find_parent_item
    if params[:parent_id]
    @parent_item = ListItem.find(params[:parent_id])
    end
  end
  private
  def find_list_item
    @list_item = ListItem.find(params[:id])
  end

  def init_list_item
  end

  def list_item_params
    params.require(:list_item).permit(:title, :parent_id, :property_id)
  end

end
