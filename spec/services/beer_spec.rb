require_relative "../../app/services/beer"
require_relative "../../app/services/brewery"
describe Beer do
  describe "initializing from table data" do

    let(:table_row) { ["Columbus 1859 Porter", "American Porter", "?", "3.92",
                        "29", "/beer/profile/341/4640", "/beer/style/159"] }

    let(:a_brewery) { Brewery.new }
    it "sets its attributes from an array of strings" do
      b = Beer.new *table_row, a_brewery
      b.should be_a(Beer)
    end
  end

end
