# Class: Wishlist
# a table containing unavailable characters that the user wants.
#
# Attributes:
# @id     - Integer : the wishlist's primary key
# @name   - String  : the name of the wishlist
# @user_id- Integer : the id of the list's owner
# @offer  - String  : The name of a Character the user is offering to trade
#
# Public Methods: 
# #add_to_wishlist

class Wishlist
  include DatabaseMethods
  extend ClassMethods
  include ModelHelper
  
  attr_reader :id, :user_id
  attr_accessor :name, :offer
  
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @user_id = options["user_id"]
    @offer = options["offer"]
  end
  
  # Public Method: #add_to_wishlist
 #  Adds an entry in the characters_to_wishlists table
 #
 #  Parameters:
 #  char_id       - Integer: The id of the character being added to the wishlist
 #
 #  Returns: nil
 #
 #  State Changes:
 #  inserts new entry into the characters_to_wishlists table
 #
  def add_to_wishlist(char_id)
    DATABASE.execute("INSERT INTO characters_to_wishlists (character_id, wishlist_id)
                    VALUES (#{char_id}, #{id})")
  end
  
  def remove_from_wishlist(char_id)
    DATABASE.execute("DELETE FROM characters_to_wishlists WHERE character_id=#{char_id}")
  end
  
  # Public Method: #set_wishlist_chars
  # Creates an array of Character objects that are on your wishlist
  #
  # Parameters: none
  #
  # Returns:
  # results        -  Array: an array of Character objects
  #
  # State Changes: none

  def set_wishlist_chars(user)
    chars = DATABASE.execute("SELECT character_id FROM characters_to_wishlists WHERE wishlist_id = #{id}")
    results = []
    chars.each do |char|
      results << Character.find("characters", char["character_id"]) 
    end
    results.each do |char|
      if char.user_id == user.id
        self.remove_from_wishlist(char.id)
        results.delete(char)
      end 
    end
    check_offer(user)
    results
  end
  
  # Public Method: #check_offer
 #  checks that the offered character is still owned by the user
 #
 #  Parameters:
 #  user             -  User: the user object
 #
 #  Returns: none
 #
 #  State Changes:
 #  @offer is set to "" if the user no longer has that character
  
  def check_offer(user)
    offered_char = Character.search_where("characters", "name", offer)[0]
    if offered_char != nil
      if offered_char.user_id != user.id
        @offer = ""
        self.save("wishlists")
      end
    end
  end
    
  
end#class end