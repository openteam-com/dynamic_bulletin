module Searchers
  class AdvertsSearcher < Searcher

    private
    def search
      Advert.search do
        any_of do
          with :list_item_ids, search_params.list_items if search_params.list_items
          with :hierarch_list_item_ids, search_params.hierarch_list_items if search_params.hierarch_list_items
        end

        paginate page: 1, per_page: 1_000_000
      end
    end
  end
end
