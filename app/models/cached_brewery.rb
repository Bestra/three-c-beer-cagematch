require 'beer'
class CachedBrewery < ActiveRecord::Base
  serialize :beers


  def self.for_url url
    b = CachedBrewery.find_by profile_url: url
    if b && b.expired?
      b.delete
      b = nil
    end
    b.try(:to_brewery)
  end

  def self.save brewery
    CachedBrewery.create(name: brewery.name, profile_url: brewery.profile_url,
                         city_name: brewery.city_name, beers: brewery.beers)
  end


  def expired?
    self.created_at < (Date.today - 1.day)
  end

  def to_brewery
    b = Brewery.new
    b.name = self.name
    b.profile_url = self.profile_url
    b.city_name = self.city_name
    b.beers = self.beers
    b.beers.each { |beer| beer.brewery = b }
    b
  end
end
