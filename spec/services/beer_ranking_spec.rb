require_relative "../../app/services/beer_ranking"
require_relative "../../app/services/city"
require_relative "../../app/services/beer"
describe BeerRanking do
  #make a beer with randomized ranking and votes
  def stub_beer(brewery_name, city_name)
     b = Beer.new "Bud", "Pilsner", "?", rand + rand(4), rand(100), "/1", "/1"
     b.stub(brewery_name: brewery_name)
     b.stub(city_name: city_name)
     b
  end

  it "returns a beer list" do
     City.stub(:create_from_url) do |url, city_name|
       c = City.new
       c.stub(:beers).and_return [stub_beer("A Brewery", city_name)]
       c
     end
     BeerRanking.beer_list.count.should == 3
  end

  describe "specifying cities to search" do
    it "only returns results from the specified cities"

    it "returns nothing from an invalid city name"

  end

  it "can filter beers by style name"
end
