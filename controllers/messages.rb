#------------------------------------------------------------------------------
#MESSAGE ROUTES
#------------------------------------------------------------------------------
["/messages/new/:id", "/messages/new"].each do |route|
  get route do
    @to_user = User.find(params["id"])
    erb :"messages/new"
  end
end

post "/messages/send" do
  params["from_user_id"] = @current_user.id
  @message = Message.create(params)
  redirect "/messages"
end

get "/messages" do
  @messages = Message.where("to_user_id = ? OR from_user_id = ?", @current_user.id, @current_user.id).reverse_order
  erb :"messages/messages"
end