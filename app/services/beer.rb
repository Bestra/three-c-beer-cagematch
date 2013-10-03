class Beer
  attr_accessor *%i(name style_name style_url profile_url brewery abv rAvg votes)

  def self.create_beers_from_brewery_table(table_rows, brewery=nil)
    table_rows.map do |row|
      Beer.new_from_table *row, brewery
    end
  end

  # initialize assuming that the parameters are strings.
  # ["Columbus 1859 Porter", "American Porter", "?",
  # "3.92", "29", "/beer/profile/341/4640", "/beer/style/159", brewery]
  def initialize(options={})
    @name = options[:name] || 'Undefined'
    @style_name = options[:style_name] || 'Undefined'
    @abv = options[:abv].to_f
    @rAvg = options[:rAvg].to_f
    @votes = options[:votes].to_i
    @profile_url = options[:profile_url] || 'Undefined'
    @style_url = options[:style_url] || 'Undefined'
    @brewery = options[:brewery]

  end

  def self.new_from_table(name, style_name, abv, avg_rating, votes,
                          profile_url, style_url, brewery=nil)
    Beer.new name: name, style_name: style_name, abv: abv, rAvg: avg_rating,
            votes: votes, style_url: style_url, profile_url: profile_url,
            brewery: brewery
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

  def json_output
    { name: name,
    style_name: style_name,
    abv: abv,
    rAvg: rAvg,
    votes: votes,
    profile_url: profile_url,
    style_url: style_url,
    brewery_name: brewery_name,
    city_name: city_name
    }
  end

end
