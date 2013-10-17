class RankedBrewery

  attr_accessor :beers, :average_rank, :name

  def self.create_breweries_from_ranked_beers(beer_list)
    breweries = {}
    beer_list.each do |beer|
      beer_name = beer[:beer][:name]
      brewery_name = beer[:beer][:brewery_name]

      breweries[brewery_name] ||= RankedBrewery.new(brewery_name)
      breweries[brewery_name].add_beer beer
    end

    breweries.values.sort {|a,b| b.average_rank <=> a.average_rank }
  end

  def initialize(name)
    @beers = []
    @average_rank = 0
    @name = name
  end

  def add_beer(new_beer)
    @beers << new_beer
    calculate_average_rank
  end

  def to_hash
    {}
  end

  private
  def calculate_average_rank
    @average_rank = @beers.map{|beer| beer[:rank]}.inject(:+) / @beers.count
  end
end
