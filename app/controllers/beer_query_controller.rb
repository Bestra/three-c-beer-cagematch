class BeerQueryController < ApplicationController

  def query
    cities = Array(params[:cities]).map{ |c| c.downcase.to_sym }
    searched_style = params[:style]
    cities = nil if cities.empty?
    list = CityBeerList.beer_list cities: cities, style: searched_style
    max_results = params[:limit].to_i
    max_results = nil if max_results <= 0
    results = RankedBeerList.new(list).ranked_beers

    if max_results
      results = results.take(max_results)
    end

    render json: results
  end
end
