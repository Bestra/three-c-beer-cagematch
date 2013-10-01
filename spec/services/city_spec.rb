require_relative "../../app/services/city"
require_relative "../../app/services/brewery"
require 'vcr'
require 'vcr_helper'
describe City do
  let(:test_url) { "http://beeradvocate.com/beerfly/city/40" }
  it "can initialize from a url" do
    VCR.use_cassette("columbus-city-profile") do
      Brewery.stub(:for_url).and_return("brewery")
      c = City.create_from_url(test_url, "Columbus")
      c.name.should == "Columbus"
      c.breweries.count.should == 10
      c.profile_url.should == test_url
    end
  end

  it "lists the beers from all its breweries"

end
