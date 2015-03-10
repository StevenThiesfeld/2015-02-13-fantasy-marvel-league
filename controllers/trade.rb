#------------------------------------------------------------------------------
#TRADE ROUTES
#------------------------------------------------------------------------------

get "/start_trade/:id" do
  @user2 = User.find(params["id"])
  @trade = Trade.new("user1" => session[:user], "user2" => @user2)
  if @trade.valid_trade
    erb :"trade/start_trade"
  else erb :"trade/bad_trade"
  end
end

post "/confirm_trade" do
  make_trade(params)
  erb :"trade/trade_finished"
end
