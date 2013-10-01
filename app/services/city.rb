require 'nokogiri'
require 'open-uri'

class City
  attr_accessor *%i(name breweries profile_url)

  def self.create_from_url(url, name="Unspecified")
    c = City.new
    c.name = name
    c.profile_url = url
    city_page = Nokogiri::HTML(open(url, read_timeout: 0.2))
    c.breweries = City.populate_breweries(city_page, name)
    c
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

