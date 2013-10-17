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

  describe "City.find_all" do
    context "with no arguments" do
      it "returns breweries from all cities" do
        City::PROFILE_URLS.each do |key, val|
          City.should_receive(:create_from_url).with(val, key.to_s.capitalize)
        end
        City.find_all
      end
    end

    context "with a list of cities" do
      let(:city_name) { :cleveland }
      let(:other_city_name) { :columbus }
      it "returns breweries from the specified cities" do
        City.should_receive(:create_from_url).with(City::PROFILE_URLS[city_name], city_name.to_s.capitalize)
        City.should_not_receive(:create_from_url).with(City::PROFILE_URLS[other_city_name], other_city_name.to_s.capitalize)
        City.find_all([city_name])
      end
    end
  end

end
