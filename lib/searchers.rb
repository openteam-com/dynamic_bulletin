module Searchers
  class Searcher
    attr_reader :search_params

    def initialize(args = {})
      @search_params = Hashie::Mash.new args
    end

    def collection
      search.results
    end
  end
end
