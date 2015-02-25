#------------------------------------------------------------------------------
#MESSAGE ROUTES
#------------------------------------------------------------------------------
["/new_message/:id", "/new_message"].each do |route|
  get route do
    @to_user = User.find("users", params["id"])
    erb :"message/new_message"
  end
end

get "/send_message" do
  params["from_user_id"] = session[:user].id
  @message = Message.new(params)
  @message.insert("messages")
  erb :"message/confirm_sent"
end

get "/your_messages" do
  @messages = Message.get_all_messages(session[:user].id)
  @messages.reverse!
  erb :"message/your_messages"
end