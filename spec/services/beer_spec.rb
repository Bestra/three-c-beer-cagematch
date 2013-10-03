require_relative "../../app/services/beer"
require_relative "../../app/services/brewery"
describe Beer do
  describe "initializing from table data" do

    let(:table_row) { ["Columbus 1859 Porter", "American Porter", "?", "3.92",
                        "29", "/beer/profile/341/4640", "/beer/style/159"] }

    let(:a_brewery) { Brewery.new }
    it "sets its attributes from an array of strings" do
      b = Beer.new_from_table *table_row, a_brewery
      b.should be_an_instance_of Beer
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
end
