class Beer
  attr_accessor *%i(name style_name style_url profile_url brewery abv rAvg votes)

  def self.create_beers_from_brewery_table(table_rows, brewery=nil)
    table_rows.map do |row|
      Beer.new *row, brewery
    end
  end

  # initialize assuming that the parameters are strings.
  # ["Columbus 1859 Porter", "American Porter", "?",
  # "3.92", "29", "/beer/profile/341/4640", "/beer/style/159", brewery]
  def initialize(name, style_name, abv, avg_rating, votes,
                      profile_url, style_url, brewery=nil)
    @name = name
    @style_name = style_name
    @abv = abv.to_f
    @rAvg = avg_rating.to_f
    @votes = votes.to_i
    @profile_url = profile_url
    @style_url = style_url
    @brewery = brewery

  end

  def brewery
    @brewery || Brewery.new
  end

  def brewery_name
    brewery.name
  end

  def city_name
    brewery.city_name
  end

end
