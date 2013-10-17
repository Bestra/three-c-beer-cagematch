class AddIndexToBreweryUrl < ActiveRecord::Migration
  def change
    add_index :cached_breweries, :profile_url
  end
end
