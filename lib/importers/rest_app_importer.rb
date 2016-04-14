class RestAppImporter
  attr_reader :data

  def initialize(params = {})
    @data = RestAppParser.new(date_from: params[:date_from]).parse
  end

  def store
    AvitoDatum.create data: data['data']
  end
end
