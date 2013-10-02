require 'nokogiri'
require 'open-uri'

class Brewery
  attr_accessor *%i(city_name name profile_url beers errors)

  def self.for_url(url, city_name="Undefined")
    b = CachedBrewery.for_url url
    if !b
      b = Brewery.new
      begin
        b.set_data_from_url url
        CachedBrewery.save b
      rescue OpenURI::HTTPError
        # if the brewery page couldn't be read return
        # an empty list of beers
        b.errors[:network] = "Loading data url timed out"
      end
    end
    b.city_name = city_name
    b
  end

  def initialize(params={})
    @beers = params[:beers] || []
    @name = params[:name] || "Undefined"
    @city_name = params[:city_name] || "Undefined"
    @errors = {}
  end

  def set_data_from_url(url)
      brewery_page = Nokogiri::HTML(open(url, read_timeout: 0.2))
      @name =  Brewery.extract_brewery_name(brewery_page)
      @profile_url = url
      @beers = create_beers(Brewery.extract_beer_tables(brewery_page))
  end

  def create_beers(data_rows)
    Beer.create_beers_from_brewery_table data_rows, self
  end

  def self.extract_brewery_name(brewery_page)
    brewery_page.css(".titleBar > h1").text
  end

  def self.extract_beer_tables(brewery_page)
    beer_tables = brewery_page.css('#baContent > table:last > tr:first tr').drop(2)
    raw_data = []
    beer_tables.each do |table|
      table_row = table.css('td').map(&:text).drop(1)
      urls = table.css('td a')[1..2].map { |u| "http://www.beeradvocate.com" + u['href'] }
      table_row += urls
      raw_data << table_row
    end
    raw_data
  end

end
