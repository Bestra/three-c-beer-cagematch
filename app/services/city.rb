require 'nokogiri'
require 'open-uri'

class City
  PROFILE_URLS = {
    columbus: "http://beeradvocate.com/beerfly/city/40",
    cincinatti: "http://beeradvocate.com/beerfly/city/39",
    cleveland: "http://beeradvocate.com/beerfly/city/5"
  }

  attr_accessor *%i(name breweries errors profile_url)

  def initialize
    @errors = {}
  end

  def self.create_from_url(url, name="Unspecified")
    c = City.new
    c.name = name
    c.profile_url = url
    tries = 0
    begin
      tries += 1
      city_page = Nokogiri::HTML(open(url, read_timeout: 5.0))
      c.breweries = City.populate_breweries(city_page, name)
    rescue Net::ReadTimeout, OpenURI::HTTPError, Zlib::BufError
      retry if tries < 3
      c.breweries = []
      c.errors[:network] = "There was a problem loading the city page"
    end
    c
  end

  def self.find_all(city_names = nil)
    city_names ||= PROFILE_URLS.keys
    cities = city_names.map do |name|
      url = City::PROFILE_URLS[name]
      if url
        City.create_from_url url, name.to_s.capitalize
      end
    end.compact
  end

  def beers
    breweries.flat_map(&:beers)
  end

  private

  def self.populate_breweries(page, city_name)
    brewery_list = City.extract_brewery_info(page)
    brewery_list.map { |brewery| Brewery.for_url brewery[1], city_name }
  end

  def self.extract_brewery_info(page)
    list = page.xpath("//h6[text()='Breweries:']/following-sibling::ul").first
    names = list.css('b').map(&:text)
    paths = list.css('a').map { |a| "http://www.beeradvocate.com" + a['href'] }
    names.zip(paths)
  end
end

