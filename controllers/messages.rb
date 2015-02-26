#------------------------------------------------------------------------------
#MESSAGE ROUTES
#------------------------------------------------------------------------------
["/messages/new/:id", "/messages/new"].each do |route|
  get route do
    @to_user = User.find("users", params["id"])
    erb :"messages/new"
  end
end

post "/messages/send/:to_user_id" do
  params["from_user_id"] = session[:user].id
  @message = Message.new(params)
  @message.insert("messages")
  redirect "/messages"
end

get "/messages" do
  @messages = Message.get_all_messages(session[:user].id)
  @messages.reverse!
  erb :"messages/messages"
end