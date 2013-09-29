class RankedBeerList
  attr_accessor :considered_beers

  def initialize(beers)
    @considered_beers = beers
  end

  MIN_VOTES = 50

  def ranked_beers
    self.considered_beers.map { |b| {rank: rank_beer(b), beer: b} }
    .sort_by { |i| i[:rank] }.reverse!
  end

  private

  # Use BeerAdvocates ranking method to sort the beers.
  # weighted rank (WR) = (v ÷ (v+m)) × R + (m ÷ (v+m)) × C
  # where:
  # R = review average for the beer
  # v = number of reviews for the beer
  # m = minimum reviews required to be listed (currently 10)
  # C = the mean across the list (currently 2.5)
  def rank_beer(beer)
    v = beer.votes.to_f
    m = MIN_VOTES.to_f
    kA = (v / (v + m)) * beer.rAvg
    kB = (m / (v + m)) * average_rating
    kA + kB
  end

  def average(property)
    considered_beers.map(&property).inject(:+) / considered_beers.count
  end


  def average_rating
     @average_rating ||= average :rAvg
  end

end
