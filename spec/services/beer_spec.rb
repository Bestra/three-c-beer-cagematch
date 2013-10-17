require_relative "../../app/services/beer"
require_relative "../../app/services/brewery"
describe Beer do
  describe "initializing from table data" do

    let(:table_row) { ["Columbus 1859 Porter", "American Porter", "?", "3.92",
                        "29", "/beer/profile/341/4640", "/beer/style/159"] }

    let(:a_brewery) { Brewery.new name: "CBC", city_name: "Columbus" }
    it "sets its attributes from an array of strings" do
      b = Beer.new_from_table *table_row, a_brewery
      b.should be_an_instance_of Beer
      b.name.should == "Columbus 1859 Porter"
      b.style_name.should == "American Porter"
      b.abv.should == 0.0
      b.rAvg.should == 3.92
      b.votes.should == 29
      b.profile_url.should == "/beer/profile/341/4640"
      b.style_url.should == "/beer/style/159"
      b.brewery_name.should == "CBC"
      b.city_name.should == "Columbus"
    end

    it "creates beers from an array of table rows" do
      new_beers = Beer.create_beers_from_brewery_table [table_row], a_brewery
      new_beers.count.should == 1
      new_beers[0].name.should == "Columbus 1859 Porter"
    end
  end

  describe "initializing from a hash" do
    let(:new_beer) { Beer.new }
    it "sets the default name and stylename to 'Undefined'" do
      new_beer.name.should == "Undefined"
      new_beer.style_name.should == "Undefined"
    end

    it "sets the default urls to 'Undefined'" do
      new_beer.profile_url.should == "Undefined"
      new_beer.style_url.should == "Undefined"
    end

    it "sets the default abv, rating, and votes to 0" do
      new_beer.abv.should == 0.0
      new_beer.rAvg.should == 0.0
      new_beer.votes.should == 0.0
    end
  end
  describe "the beer's brewery" do
    let (:city) { "Columbus" }
    let (:name) { "CBC" }
    let(:brewery) { Brewery.new city_name: city, name: name }
    let(:beer) { Beer.new brewery: brewery }

    it "returns the brewery's name" do
      beer.brewery_name.should == "CBC"
    end

    it "returns the name of the brewery's city" do
      beer.city_name.should == "Columbus"
    end

    it "returns a new brewery if the brewery hasn't been set" do
      b = Beer.new
      b.brewery.should_not be_nil
      b.brewery_name.should == "Undefined"
      b.city_name.should == "Undefined"
    end

  end

end
