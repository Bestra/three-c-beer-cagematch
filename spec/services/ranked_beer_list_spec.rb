require_relative "../../app/services/ranked_beer_list"
describe RankedBeerList do
  def stub_beer_values(rAvg, votes)
    a = double("Beer")
    a.stub(:votes).and_return(votes)
    a.stub(:rAvg).and_return(rAvg)
    a.stub(:json_output).and_return({ votes: votes, rAvg: rAvg })
    a
  end

  it "gives a same-ranked beer with more votes a better score than a beer with fewer votes" do
    beers = [stub_beer_values(3.0, 7), stub_beer_values(3.0, 1), stub_beer_values(2.0, 1)]
    ranked_beers = RankedBeerList.new(beers).ranked_beers
    ranked_beers[0][:rank].should be > ranked_beers[1][:rank]
    ranked_beers[0][:beer][:votes].should == 7
  end

end
