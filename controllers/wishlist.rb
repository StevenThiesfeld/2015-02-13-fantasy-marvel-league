#------------------------------------------------------------------------------
#WISHLIST ROUTES
#------------------------------------------------------------------------------

get "/wishlist" do
  @your_chars = session[:user].get_characters("user_id")
  @wishlist = Wishlist.search_where("wishlists", "user_id", session[:user].id)[0]
  @chars_on_wishlist = @wishlist.set_wishlist_chars
  erb :"wishlist/wishlist"
end

get "/wishlist/all" do
  @users = User.all("users")
  erb :"wishlist/all"
end

post "/wishlist/add_offer" do
  @wishlist = Wishlist.search_where("wishlists", "user_id", session[:user].id)[0]
  @wishlist.offer = params["name"]
  @wishlist.save("wishlists")
  redirect "/wishlist"
end

get "/wishlist/add/:name" do
  wishlist = Wishlist.search_where("wishlists", "user_id", session[:user].id)[0]
  char = Character.search_where("characters", "name", params["name"])[0]
  wishlist.add_to_wishlist(char.id)
  redirect "/wishlist"
end
