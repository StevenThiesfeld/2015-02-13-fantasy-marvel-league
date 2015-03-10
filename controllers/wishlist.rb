#------------------------------------------------------------------------------
#WISHLIST ROUTES
#------------------------------------------------------------------------------

get "/wishlist" do
  @your_chars = session[:user].characters
  @wishlist = session[:user].wishlist
  @chars_on_wishlist = @wishlist.characters
  erb :"wishlist/wishlist"
end

get "/wishlist/all" do
  @users = User.all
  erb :"wishlist/all"
end

post "/wishlist/add_offer" do
  @wishlist = session[:user].wishlist
  @wishlist.update(offer: params["offer"])
  redirect "/wishlist"
end

get "/wishlist/add/:name" do
  wishlist = session[:user].wishlist
  char = Character.find_by(name: params["name"])
  CharactersWishlist.create(character_id: char.id, wishlist_id: wishlist.id)
  redirect "/wishlist"
end
