<h1>Beer as a (web) service</h1>
<br>
<h2>WAT</h2>
<div class="description">
  <p><b>This site ranks beers</b> from the 3Cs, Columbus, CLeveland, and Cincinatti via their www.beeradvocate.com ratings.  It serves the data out as an array of json objects.</p>
  <p>Beers are ranked according to their average rating and the number of votes for each beer.</p>
</div>


<h2>Usage</h2>
<div class="usage">
  <h3>You can send a GET request to <a href="beers">three-c-brewery-cagematch.herokuapp.com/beers</a></h3>
  <p>You'll get back a JSON array with the beer's ranking and the beer's properties. Some of the fields are self-explanatory but here are a few:</p>
  <dl>
    <dt>rank</dt>
    <dd>This is the weighted rating of the beer. Compared to the beer's average rating it will likely be slightly lower.</dd>
    <dt>beer.rAvg</dt>
    <dd>The average rating for the beer on beeradvocate.</dd>
    <dt>beer.votes</dt>
    <dd>The number of ratings that the beer has been given.  rAvg and votes both contribute to the beer's weighted rating.</dd>
    <dt>beer.abv</dt>
    <dd>The beer's alchohol by volume percentaage. Beeradvocate lists many beers' abv as "?", and in that case the abv will be 0.0 </dd>
  </dl>
  </br>
  <p>There are a few <b>parameters</b> you can specify in order to cull the data and also change the rankings.</p>
  <dl>
    <dt>cities</dt>
    <dd>An array of city names.  If left blank beers from all three Cs are ranked and output. <code>/beers?cities[]=Columbus&cities[]=cleveland</code></dd> will return beers from just Columbus and Cleveland.
    <dt>style</dt>
    <dd>A string to filter beer style names by.  <b>Style is case sensitive</b>, so if you want IPAs, use <code>/beers?style=IPA</code></dd> You can find a <a href="http://beeradvocate.com/beer/style"> list of styles on beeradvocate to search from</a>.
    Your search string will be converted into a regular expression, so match away!
    <dt>limit</dt>
    <dd>Trims the rankings to the specified number of entries.<code>/beers?limit=5</code> returns the top 5 ranked beers specified.</dd>
  </dl>
  <p>Specifiying styles and cities will change how the beers are ranked. The cagematch uses the same ranking formula as <a href="http://beeradvocate.com/lists/top">beeradvocate's top 250 beers</a>, but recalculates the mean list ranking based on the pool of
  beers that the search comes up with.  Thus, you'll see a different ranked score for the same beer in different contexts.  The <code>limit</code> simply returns less data after the rankings are calculated.</p>
</div>

<h2>Details</h2>
<p>Results per brewery are cached daily to avoid hitting beeradvocate too much.  The Brewery index for each city is always scraped in real-time, though.  If there's a network problem you just won't see data for a particular city or brewery.  Beeradvocate can get pretty slow
at times so be patient and try back later if you're not getting any results.</p>

<h2>An Example</h2>
<p> I want to see the top ranked beer from IPAs or stouts made in Cleveland and Columbus.
<p>For the given query <code>http://three-c-beer-cagematch.herokuapp.com/beers?cities[]=Columbus&cities[]=cleveland&style=(Stout)|(IPA)&limit=1</code></p>

<pre>
[
  {
  "rank":4.353502603069769,
  "beer":{
    "name":"Columbus Bodhi DIPA",
    "style_name":"American Double / Imperial IPA",
    "abv":8.0,
    "rAvg":4.48,
    "votes":327,
    "profile_url":"http://www.beeradvocate.com/beer/profile/341/53187",
    "style_url":"http://www.beeradvocate.com/beer/style/140",
    "brewery_name":"Columbus Brewing Company",
    "city_name":"Columbus"}
  }
]</pre>
