class CreateCachedBreweries < ActiveRecord::Migration
  def change
    create_table :cached_breweries do |t|
      t.string :name
      t.string :profile_url
      t.string :city_name
      t.text :beers

      t.timestamps
    end
  end
end
