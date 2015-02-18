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
  
end#class end