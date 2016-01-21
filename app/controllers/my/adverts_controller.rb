class My::AdvertsController < My::ApplicationController
  before_action :find_category, only: [:new, :create]
  before_action :find_advert, only: [:show, :edit, :update, :destroy]

  def index
    @adverts = Advert.all
  end

  def new
    if @category
      @advert = @category.adverts.build
    else
      @categories = Category.ordered
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

  private
  def advert_params
    params.require(:advert).permit(:description, values_attributes: [:string_value, :property_id, :id, :list_item_id, list_item_ids: []])
  end

  def find_advert
    @advert = Advert.find(params[:id])
  end

  def find_category
    @category = Category.find_by_id(params[:category_id] || params[:advert].try(:[], :category_id))
  end
end
