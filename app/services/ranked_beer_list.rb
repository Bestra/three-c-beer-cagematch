class RankedBeerList
  attr_accessor :considered_beers

  def initialize(beers)
    @considered_beers = beers
  end

  # use a bayesian ranking for the beers
  # (average_votes * average_rating)
  def ranked_beers
    self.considered_beers.map { |b| {rank: rank_beer(b), beer: b} }
    .sort_by { |i| i[:rank] }
  end

  private

  def rank_beer(beer)
    kA = (average_votes * average_rating)
    kB = (beer.votes * beer.rAvg)
    kC = (average_votes + beer.votes)
    (kA + kB) / kC
  end

  def average(property)
    considered_beers.map(&property).inject(:+) / considered_beers.count
  end

  def average_votes
     @average_votes ||= average :votes
  end

  def average_rating
     @average_rating ||= average :rAvg
  end

end
