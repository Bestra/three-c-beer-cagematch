def stub_beer(brewery_name= "A brewery", city_name="Columbus", style_name="Pilsner")
   b = Beer.new "Bud", style_name, "?", rand + rand(4), rand(100), "/1", "/1"
   b.stub(brewery_name: brewery_name)
   b.stub(city_name: city_name)
   b
end
