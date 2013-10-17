require 'spec_helper'
require 'beer_stubbing'
describe BeerQueryController do
  describe "limiting results" do
    before(:each) do
      CityBeerList.stub(:beer_list).and_return(10.times.map { stub_beer })
    end

    it "returns all results if no limit is specified" do
      get :query
      expect(response).to be_success
      JSON.parse(response.body).count.should == 10
    end

    it "limits the number of results" do
      get :query, limit: 2
      JSON.parse(response.body).count.should == 2
    end

    it "returns all results if the limit is invalid or negative" do
      get :query, limit: -1
      JSON.parse(response.body).count.should == 10
    end
  end
end
