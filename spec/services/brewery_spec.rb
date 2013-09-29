require_relative "../../app/services/brewery"
require_relative "../../app/services/beer"
require 'vcr'
require 'vcr_helper'
describe Brewery do
  it "can initialize from a url" do
    VCR.use_cassette("cbc-profile-page") do
      b = Brewery.from_url("http://beeradvocate.com/beer/profile/341")
      b.name.should == "Columbus Brewing Company"
      b.beers.count.should == 39
    end
  end
end
