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
# #remove_from_wishlist
# #get_char_ids
# #set_wishlist_chars
# #check_offer
# #delete_wishlist

class Wishlist < ActiveRecord::Base
  # include DatabaseMethods
#   extend ClassMethods
  include ModelHelper
 
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @user_id = options["user_id"]
    options["offer"] ? @offer = options["offer"] : @offer = "none"
  end
  
  after_initialize :defaults
  
  def defaults
    self.offer ||= "none"
  end
  has_many :characters_wishlists
  has_many :characters, :through => :characters_wishlists
  belongs_to :user
  # Public Method: #add_to_wishlist
 #  Adds an entry in the characters_to_wishlists table
 #
 #  Parameters:
 #  char_id       - Integer: The id of the character being added to the wishlist
 #
 #  Returns: self     - the Wishlist object
 #
 #  State Changes:
 #  inserts new entry into the characters_to_wishlists table
 #
  def add_to_wishlist(char_id)
    DATABASE.execute("INSERT INTO characters_to_wishlists (character_id, wishlist_id)
                    VALUES (#{char_id}, #{id})")
    self                
  end
  
  def remove_from_wishlist(char_id)
    DATABASE.execute("DELETE FROM characters_to_wishlists WHERE character_id=#{char_id}")
  end
  
  # Public Method: #get_char_ids
#   returns an array of character ids on the wishlist
#
#   Parameters: none
#
#   Returns:
#   char_ids        - Array: an array of character IDs that are on the user's wishlist
#
#   State Changes: none
  
  def get_char_ids
   char_ids = []
   self.characters.each{|char| char_ids << char.id if char}
   char_ids
 end
    
  
  # Public Method: #set_wishlist_chars
  # Creates an array of Character objects that are on your wishlist
  #
  # Parameters: none
  #
  # Returns:
  # char_objects        -  Array: an array of Character objects
  #
  # State Changes: will call remove_from_wishlist if the character has been aquired

  def set_wishlist_chars
    self.characters.each do |char|
      if char.user_id == user_id
        self.remove_from_wishlist(char.id)
      end 
    end
    check_offer
    char_objects
  end
  
  # Public Method: #check_offer
 #  checks that the offered character is still owned by the user
 #
 #  Parameters:
 #  none
 #
 #  Returns: self  - the Wishlist acted upon
 #
 #  State Changes:
 #  @offer is set to "" if the user no longer has that character
  
  def check_offer
    offered_char = Character.find_by(name: offer)
    if offered_char != nil
      if offered_char.user_id != user_id
        self.update(offer: "none")
      end
    else 
      self.update(offer: "none")
    end 
  end
  
  # Public Method: #delete_wishlist
#   Deletes relevant info from the wishlist and characters_to_wishlists tables
#
#   Returns: self - the Wishlist acted upon
#
#   State Changes:
#   Deletes entries from characters_to_wishlists where the wishlist ids match
#   Deletes the corresponding wishlist entry from the table
  
  def delete_wishlist
    DATABASE.execute("DELETE FROM characters_to_wishlists WHERE wishlist_id = #{id}")
    self.destroy
    self
  end
    
  
end#class end