require 'nokogiri'
require 'open-uri'

class City
  attr_accessor *%i(name breweries profile_url)

  def self.create_from_url(name, url)
    c = City.new
    c.name = name
    c.profile_url = url
    city_page = Nokogiri::HTML(open(url, read_timeout: 0.2))
    c.breweries = create_breweries(city_page)
    c
  end

  private

  def self.create_breweries(page)
    brewery_list = extract_brewery_info(page)
    brewery_list.map { |brewery| Brewery.from_url brewery[1] }
  end

  def self.extract_brewery_info(page)
    list = page.xpath("//h6[text()='Breweries:']/following-sibling::ul").first
    names = list.css('b').map(&:text)
    paths = list.css('a').map { |a| "http://www.beeradvocate.com" + a['href'] }
    names.zip(paths)
  end
end

