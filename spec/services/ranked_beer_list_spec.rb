require_relative "../../app/services/ranked_beer_list"
describe RankedBeerList do
  def stub_beer(rAvg, votes)
    a = double("Beer")
    a.stub(:votes).and_return(votes)
    a.stub(:rAvg).and_return(rAvg)
    a
  end

  it "gives a same-ranked beer with more votes a better score than a beer with fewer votes" do
    beers = [stub_beer(3.0, 7), stub_beer(3.01, 1)]
    ranked_beers = RankedBeerList.new(beers).ranked_beers
    ranked_beers[0][:rank].should be < ranked_beers[1][:rank]
    ranked_beers[0][:beer].votes.should == 7
  end

end
