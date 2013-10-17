require_relative "../../app/services/ranked_brewery.rb"

describe RankedBrewery do

  it "returns an empty hash when it's initialized" do
    RankedBrewery.new.to_hash.should == {}
  end

  context "beers from two breweries" do
    let(:beers) do
      [{rank: 2, beer: {name: "a", votes: 3, brewery_name: "Bad"}},
       {rank: 4, beer: {name: "b", votes: 3, brewery_name: "Bad"}},
       {rank: 5, beer: {name: "c", votes: 4, brewery_name: "Good"}}]
    end

    let(:breweries) { RankedBrewery.create_breweries_from_ranked_beers(beers) }

    it "creates RankedBreweries from a list of ranked beers" do
      breweries.map(&:name).should include("Good", "Bad")
    end

    it "sorts the breweries by their average ranking" do
      breweries.map(&:name).should == ["Good", "Bad"]
    end

    it "calculates the average ranking of the beers for each brewery" do
      breweries.first.average_rank.should == 4
    end
  end

end
