class ComparisonCategories
  attr_reader :rest_app_category

  def initialize(params = {})
    @rest_app_category = params[:category_id]
  end

  def search
    collection.select { |hash| hash if hash[:rest_app_category_id] == rest_app_category }
  end

  private
  def collection
    [
      {
        rest_app_category_id: 9,
        root_category_id: 304,
        self_category_id: 305
      },
      {

      },
      {
        rest_app_category_id: 24,
        root_category_id: 338,
        self_category_id: 339
      }
    ]
  end
end
