class CityBreweryList
  def self.brewery_list(options={})
    cities = City.find_all(options[:cities])
    cities.flat_map(&:breweries)
  end
end
