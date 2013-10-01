class BeerRanking
  PROFILE_URLS = {
    columbus: "http://beeradvocate.com/beerfly/city/40",
    cincinatti: "http://beeradvocate.com/beerfly/city/39",
    cleveland: "http://beeradvocate.com/beerfly/city/5"
  }

  def self.beer_list(options={})
    city_names = options[:cities] || %i(columbus cleveland cincinatti)
    style = options[:style]

    cities = city_names.map do |name|
      url = PROFILE_URLS[name]
      if url
        City.create_from_url url, name.to_s.capitalize
      end
    end.compact

    all_beers = cities.flat_map(&:beers)

  end

end
