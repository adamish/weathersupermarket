class SearchController < ApplicationController
  def initialize
    @location_service = SearchService.instance()
    @providers = Provider.all
  end

  def search()
    results = []

    locations = @location_service.request(params[:query].downcase)

    groups = Hash.new
    locations.each do |l|
      list = groups[l.provider.id]
      if list == nil
        list = Array.new
        groups[l.provider.id] = list
      end
      list.push(l)
    end
    out = Array.new
    @providers.each do |p|
      result = Hash.new
      result['results'] = groups[p.id]
      if result['results'] == nil
        result['results'] = []
      end
      result['provider'] = p.name
      out.push(result)
    end

    render :json => out.to_json
  end
end
