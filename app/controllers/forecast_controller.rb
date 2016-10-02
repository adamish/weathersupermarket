require 'forecast_service'

class ForecastController < ApplicationController
  def initialize
    @forecast_service = ForecastService.new
  end

  def getForecasts()
    ids = params[:ids].split(",");
    if ids.length > 6
      render :text => 'Bad request', :status => '503'
    end
    locations = Array.new
    ids.each do |it|
      unless /\d+/.match(it)
        render :text => 'Bad request', :status => '503'
        return
      end
    end

    locations = []
    begin
      locations = Location.find(ids)
    rescue Exception => e
      Rails.logger.info "Cannot find location #{ids}"
      render :text => 'Unknown location request', :status => '503'
      return
    end
    locations.each do |location|
      location.provider = ProviderDao.find(location.provider_id)
    end
    forecasts = @forecast_service.fetch(locations)
    render :json => forecasts.as_json(), content_type: "application/json"
  
    ActiveRecord::Base.connection_pool.release_connection
  end

  def getLink()
    links = Quicklink.where("quicklink = ?", params[:quicklink]).first

    render template: "forecasts/summary", :locals => { :locations => links.locations.to_json }
  end

end
