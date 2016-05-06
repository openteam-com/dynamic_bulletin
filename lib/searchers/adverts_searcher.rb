module Searchers
  class AdvertsSearcher < Searcher
    private
    def search
      Advert.search do
        with :category_id, search_params.category_id if search_params.category_id
        any_of do
          with :list_item_ids, search_params.list_items if search_params.list_items
          with :hierarch_list_item_ids, search_params.hierarch_list_items if search_params.hierarch_list_items
        end

        paginate page: search_params.page, per_page: 30
      end
    end
  end
end
