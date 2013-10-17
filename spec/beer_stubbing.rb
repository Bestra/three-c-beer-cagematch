def stub_beer(brewery_name= "A brewery", city_name="Columbus", style_name="Pilsner")
   b = Beer.new name: "Bud", style_name: style_name, rAvg: rand + rand(4), votes: rand(100)
   b.stub(brewery_name: brewery_name)
   b.stub(city_name: city_name)
   b
end
