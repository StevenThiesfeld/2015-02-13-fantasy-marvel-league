require "pry"
require 'marvelite'
class SearchEngine
  attr_reader :response

  def initialize(options)
    @client = Marvelite::API::Client.new( :public_key =>  
                '4de5aeb0ed9b963eea1608e13c1eff02', :private_key => 
                '8145779d67b193e6d3a7da2b7d1df809804b7ca8')
            
    # @user_search = options["user_search"]
    @user_id = options["user_id"]
  end
  
  def generate_character_list
    response = @client.characters
    response["data"]["results"].each do |result|
      options = {}
      options["name"] = result["name"]
      options["description"] = result["description"]
      options["popularity"] = result["comics"]["available"]
      options["image"] = result["thumbnail"]["path"] + "." + result["thumbnail"]["extension"] if result["thumbnail"] != nil
      options["user_id"] = nil
      char = Character.new(options)
      char.insert("characters")    
    end
  end
  
  def create_character(user_search)
    results = []
    response = @client.characters(:nameStartsWith => user_search)
    response["data"]["results"].each do |result|
      options = {}
      options["name"] = result["name"]
      if result["description"] == ""
        options["description"] = "No description found"
      else
        options["description"] = result["description"]
      end
      options["popularity"] = result["comics"]["available"]
      options["image"] = result["thumbnail"]["path"] + "." + result["thumbnail"]["extension"] if result["thumbnail"] != nil
      options["user_id"] = @user_id
      results << Character.new(options)
    end
    results    
  end
  
  def verify_response
    if @response["code"] == 404
    end
  end
  
end#class end

 