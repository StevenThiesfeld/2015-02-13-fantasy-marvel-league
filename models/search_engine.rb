class SearchEngine

  def initialize(options)
    @client = Marvelite::API::Client.new( :public_key =>  
                '4de5aeb0ed9b963eea1608e13c1eff02', :private_key => 
                '8145779d67b193e6d3a7da2b7d1df809804b7ca8')
            
    @user_search = options["user_search"]
    @response = @client.character(@user_search)
    @user_id = options["user_id"]
  end
  
  def create_character
    if DATABASE.execute("SELECT name FROM characters WHERE name=#{@response["data"]["results"][0]["name"]}") == []
      options = {}
      options["name"] = @response["data"]["results"][0]["name"]
      options["description"] = @response["data"]["results"][0]["description"]
      options["popularity"] = @response["data"]["results"][0]["comics"]["available"]
      options["image"] = @response["data"]["results"][0]["thumbnail"]["path"] + "." + @response["data"]["results"][0]["thumbnail"]["extension"]
      options["attribution"] = @response["attributionText"]
      options["user_id"] = @user_id
      result = Character.new(options)
      result
    else "error-character already assigned to a user"
    end
  end
  
end#class end


