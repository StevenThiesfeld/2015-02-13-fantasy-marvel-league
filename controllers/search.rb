get "/search" do
  erb :"search/search"
end

post "/search_results" do
  client = SearchEngine.new(params)
  if client.error == ""
    @char_results = client.search_for_chars
    erb :"search/search_results"
  else
    @error = client.error
    erb :"search/search"
  end
end