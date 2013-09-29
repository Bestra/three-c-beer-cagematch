require 'nokogiri'
require 'open-uri'

class Brewery
  attr_accessor :city_name, :name, :url, :beers

  def self.from_url(url)
    b = Brewery.new
    brewery_page = Nokogiri::HTML(open(url))
    b.name =  brewery_page.css(".titleBar > h1").text
    beer_tables = brewery_page.css('#baContent > table:last > tr:first tr').drop(2)
    raw_data = []
    beer_tables.each do |table|
      table_row = table.css('td').map(&:text).drop(1)
      urls = table.css('td a')[1..2].map { |u| u['href'] }
      table_row += urls
      raw_data << table_row
    end
    b.beers = raw_data
    b
  end
end
