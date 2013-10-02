require_relative "../../app/services/city_beer_list"
require_relative "../../app/services/city"
require_relative "../../app/services/beer"
describe CityBeerList do
  #make a beer with randomized ranking and votes
  def stub_beer(brewery_name, city_name, style_name="Pilsner")
     b = Beer.new "Bud", style_name, "?", rand + rand(4), rand(100), "/1", "/1"
     b.stub(brewery_name: brewery_name)
     b.stub(city_name: city_name)
     b
  end

  RSpec::Matchers.define :have_beers_from do |expected_cities|
    match do |beer_list|
      city_names(beer_list) == expected_cities.sort
    end

    failure_message_for_should do |beer_list|
      "Found cities: #{city_names(beer_list)} should match #{expected_cities}"
    end

    def city_names(list)
      list.map(&:city_name).uniq.sort
    end

  end

  RSpec::Matchers.define :return_styles do |expected_styles|
    match do |beer_list|
      style_names(beer_list) == expected_styles.sort
    end

    failure_message_for_should do |beer_list|
      "Found styles: #{style_names(beer_list)} should match #{expected_styles}"
    end

    def style_names(list)
      list.map(&:style_name).uniq.sort
    end

  end

  describe "listing beers from each city" do
    before(:each) do
     City.stub(:create_from_url) do |url, city_name|
       c = City.new
       c.stub(:beers).and_return [stub_beer("A Brewery", city_name)]
       c
     end
    end

    it "returns a beer list for Cleveland, Columbus, and Cincinatti" do
       CityBeerList.beer_list.count.should == 3
       CityBeerList.beer_list.should have_beers_from %w(Cleveland Columbus Cincinatti)
    end

    it "only returns results from the specified cities" do
      CityBeerList.beer_list(cities: [:cleveland]).should have_beers_from ["Cleveland"]
      CityBeerList.beer_list(cities: [:cleveland, :columbus]).should have_beers_from ["Cleveland", "Columbus"]
    end

    it "returns an empty list from an invalid city name" do
      CityBeerList.beer_list(cities: [:capybara]).count.should == 0
    end

  end

  it "can filter beers by style name" do
     City.stub(:create_from_url) do |url, city_name|
       c = City.new
       test_beers = ["Rye Beer", "American IPA", "English IPA"].map do |name|
         stub_beer "CBC", city_name, name
       end
       c.stub(:beers).and_return test_beers
       c
     end

     CityBeerList.beer_list(cities: [:columbus], style: "IPA")
     .should return_styles ["American IPA", "English IPA"]

     CityBeerList.beer_list(cities: [:columbus], style: "Rye")
     .should return_styles ["Rye Beer"]

     CityBeerList.beer_list(cities: [:columbus])
     .should return_styles ["Rye Beer", "American IPA", "English IPA"]
  end
end
