require 'marvelite'
require 'pry'
# Class: SearchEngine
# Accesses the Marvel API client and searches for the user's query
#
# Attributes:
# @client      - Client: the gem client that accesses the API database
# @user_search - String: the user's query
# @user_id     - Integer: the id of the user making the search
#
# Public Methods:
# #generate_character_list
# #create_character

class SearchEngine
  attr_reader :response

  def initialize(options)
    @client = Marvelite::API::Client.new( :public_key =>  
                '4de5aeb0ed9b963eea1608e13c1eff02', :private_key => 
                '8145779d67b193e6d3a7da2b7d1df809804b7ca8')
            
    @user_search = options["user_search"]
    @user_id = options["user_id"]
  end
  
# Public Method: #create_character
# Searches the Marvel database and returns an array of Character objects
#
# Parameters:
# user_search      - String: the query from the user
# options          - Hash:   the character's information extracted from the response
#
# Returns:
# results      - Array: An array of Character objects
#
# State Changes:
# Creates new character objects with data from the API and inserts them into the
# results array
  
  def create_character
    results = []
    response = @client.characters(:nameStartsWith => @user_search)
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
      options["team_id"] = 0
      results << Character.new(options)
    end
    results    
  end
  
  def fetch_comics(name)
    response = @client.character_comics(
    "#{name}",
    { :noVariants => true, :limit => 10, :orderBy => 'unlimitedDate' }
    )
    response
  end
  
end#class end
 