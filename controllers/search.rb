get "/search" do
  erb :"search/search"
end

get "/search_results" do
  client = SearchEngine.new(params)
  @char_results = client.search_for_chars
  erb :"search/search_results"
end