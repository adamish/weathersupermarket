Wsm2::Application.routes.draw do
  get "/app/search/:query", to: 'search#search'
  get "/app/forecasts/:ids", to: 'forecast#getForecasts'
end

# constraints: IpConstraint.new