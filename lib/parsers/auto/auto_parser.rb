class AutoParser
  attr_reader :url, :results, :start_time,
    :marks_data, :models

  def initialize(args = {})
    @url = args[:url]
    @results = {}
  end

  def do_parse
    parse_marks
    parse_models
    results.to_json
  end

  def nokogiri_object(url = @url)
    Nokogiri::HTML(open(url))
  end
end
