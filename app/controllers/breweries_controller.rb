class BreweriesController < ApplicationController
  def index
    ranked_beers = RankedBeerList.new(CityBeerList.beer_list).ranked_beers
    breweries = ranked_beers.inject({}) do |breweries, ranking|
      name = ranking[:beer][:brewery_name]
      breweries[name] ||= []
      breweries[name] << {beer: ranking[:beer][:name], votes: ranking[:beer][:votes], rank: ranking[:rank]}
      breweries
    end

    @breweries = breweries.map do |name, beer_info|
      avg = beer_info.reduce(0) do |sum, beer|
        sum += beer[:rank]
      end

      avg = avg/beer_info.count

      { name: name, beers: beer_info, average_rank: avg }
    end.sort {|a,b| b[:average_rank] <=> a[:average_rank] }

  end
end
