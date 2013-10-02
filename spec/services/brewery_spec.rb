require_relative "../../app/services/brewery"
require_relative "../../app/services/beer"
require 'vcr'
require 'vcr_helper'
describe Brewery do
  it "can initialize from a hash"

  let(:test_url) { "http://beeradvocate.com/beer/profile/341" }
  let(:fake_class) { Class.new }
  let(:cached_brewery) { Brewery.new }
  before(:each) do
    stub_const "CachedBrewery", fake_class
  end

  describe "it returns a brewery given a url and city name" do
    context "with an existing cached result" do
      before(:each) do
          CachedBrewery.stub(:for_url).and_return(cached_brewery)
      end

      it "returns the cached result" do
          CachedBrewery.should_not_receive(:save)
          b = Brewery.for_url(test_url)
          b.should == cached_brewery
      end
    end

    context "without an existing result" do
      before(:each) { CachedBrewery.stub(:for_url).and_return(nil) }
      it "calculates and saves a new cached result if none exists" do
        VCR.use_cassette("cbc-profile-page") do
          CachedBrewery.should_receive(:save)
          b = Brewery.for_url(test_url)
          b.name.should == "Columbus Brewing Company"
          b.beers.count.should == 39
        end
      end

      it "returns a brewery with an empty beer list and an error message
      if there's an HTTPError while loading the brewery data" do
        Brewery.any_instance.stub(:set_data_from_url)
        .and_raise(OpenURI::HTTPError.new("a message", 1))

        b = Brewery.for_url(test_url)
        b.beers.should == []
        b.errors[:network].should_not be_nil
      end
    end
  end
end
