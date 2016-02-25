class My::AdvertsController < My::ApplicationController
  include Breadcrumbs

  before_action :find_category, only: [:new, :create]
  before_action :find_advert, only: [:show, :edit, :update, :destroy]
  #after_action :initialize_breadcrumbs, only: :new

  def index
    @adverts = current_user.adverts
  end

  def new
    if @category
      if @category.children.present?
        @categories = @category.children
      else
        @advert = @category.adverts.build
      end
    else
      @categories = Category.roots.ordered
    end
  end

  def create
    @advert = @category.adverts.create(advert_params)

    respond_with @advert, location: -> { [:my, @advert] }
  end

  def edit
  end

  def show
  end

  def update
    @advert.update(advert_params)

    respond_with @advert, location: -> { [:my, @advert] }
  end

  def destroy
    @advert.destroy

    respond_with @advert, location: -> { my_adverts_path }
  end

  def get_category_children
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
  def advert_params
    params.
      require(:advert).
      permit(:description, :category_id, :user_id,
             values_attributes: [:string_value, :integer_value,
                                 :property_id, :id,
                                 :list_item_id,
                                 :hierarch_list_item_id,
                                 :category_id,
                                 list_item_ids: []])
  end

  def find_advert
    @advert = Advert.find(params[:id])
  end

  def find_category
    @category = Category.find_by_id(params[:category_id] || params[:advert].try(:[], :category_id))
  end

  def initialize_breadcrumbs
    breadcrumbs_create(@category)
  end
end
