require "spec_helper"
describe CachedBrewery do

  let(:beer1) { Beer.new "Bud", "Pilsner", "?", "3", "12", "/1", "/1" }
  let(:beer2) { Beer.new "Lite", "Pilsner", "?", "4", "12", "/2", "/1" }
  let(:url) { "/beer/1" }
  let(:test_name) { "Test Brewery" }
  let(:test_brewery) do
    b = Brewery.new
    b.name = test_name
    b.city_name = "Columbus"
    b.profile_url = url
    b.beers = [beer1, beer2]
    b
  end

  it "returns a cached brewery from a url" do
    CachedBrewery.create!(profile_url: url, name: test_name, city_name: "Columbus", beers: [beer1, beer2])
    b = CachedBrewery.for_url url
    b.should be_an_instance_of Brewery
    b.name.should == test_name
    b.beers[0].name.should == "Bud"
    b.beers[1].name.should == "Lite"
  end

  it "returns nil if the brewery doesn't exist in the cache" do
    b = CachedBrewery.for_url url
    b.should be_nil
  end

  it "returns nil if a cached brewery is more than a day old" do
    cb = CachedBrewery.create!(profile_url: url, name: "Test", city_name: "Columbus", beers: [beer1, beer2])
    cb.created_at = Date.today - 5.days
    cb.save
    b = CachedBrewery.for_url url
    b.should be_nil
  end


  it "saves a brewery to the cache" do
    CachedBrewery.save test_brewery
    b = CachedBrewery.for_url url
    b.should be_an_instance_of Brewery
    b.name.should == test_name
    b.beers[0].name.should == "Bud"
    b.beers[1].name.should == "Lite"
  end

end
