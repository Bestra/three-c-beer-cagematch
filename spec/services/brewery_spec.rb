require_relative "../../app/services/brewery"
require_relative "../../app/services/beer"
require 'vcr'
require 'vcr_helper'
describe Brewery do
  it "can initialize from a url" do
  end

  let(:test_url) { "http://beeradvocate.com/beer/profile/341" }
  let(:fake_class) { Class.new }
  before(:each) do
    stub_const "CachedBrewery", fake_class
  end
  it "returns a cached result if it exists" do
      cached_brewery = Brewery.new
      CachedBrewery.stub(:for_url).and_return(cached_brewery)
      CachedBrewery.should_not_receive(:save)
      b = Brewery.for_url(test_url)
      b.should == cached_brewery
  end

  it "calculates and saves a new cached result if none exists" do
    VCR.use_cassette("cbc-profile-page") do
      CachedBrewery.stub(:for_url).and_return(nil)
      CachedBrewery.should_receive(:save)
      b = Brewery.for_url(test_url)
      b.name.should == "Columbus Brewing Company"
      b.beers.count.should == 39
    end
  end

end
