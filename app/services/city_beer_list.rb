class CityBeerList
  def self.beer_list(options={})
    cities = City.find_all(options[:cities])
    style = options[:style]

    all_beers = cities.flat_map(&:beers)

    if style
      all_beers.select do |beer|
        beer.style_name.match style.to_s
      end
    else
      all_beers
    end
  end

end
