# Class: Trade
# A forum for one user to trade with another
#
# Attributes:
# @user1         -   User: the user initiating the trade
# @user2         -   User: the user that recieved the trade request
# @user2_wishlist-   Wishlist: the wishlist object for the 2nd user
# @user1_valid_chars-Array: an array of chracter objects the 1st user owns that
#                           appear on the 2nd user's wishlist
# @user2_char    -   Character: the character object the 2nd user has offered
# @valid_trade   -   Boolean:  true if user1 has a character the 2nd player wants
#                              false if the 1st player doesn't
# Private Methods:
# #set_user2_char
# #set_valid_trade                                           

class Trade
  
  attr_reader :valid_trade
  
  attr_accessor :user1, :user2, :user2_char, :user1_valid_chars, :user2_wishlist
  
  def initialize(options)
    @user1 = options["user1"]
    @user2 = options["user2"]
    @user2_wishlist = @user2.get_wishlist
    @user1_valid_chars = []
    set_user2_char
    @user2_char != nil ? set_valid_trade : @valid_trade = false
  end
  
  private
  # Private Method: set_user2_char
#   Sets the @user2_char to the offered character object
#
#   Parameters: none
#
#   Returns: none
#
#   State Changes:
#   @user2_char is set to the character object that matches the name of the wishlist's offered attribute

  def set_user2_char
    char_name = user2_wishlist.offer
    @user2_char = Character.search_where("characters", "name", char_name)[0]
  end
  
  # Private Method: set_valid_trade
 #  Generates a list of characters that are trade candidates and sets @valid_trade
 #
 #  Parameters: none
 #
 #  Returns: none
 #
 #  State Changes:
 #  @user1_valid_chars set to an array of character objects the first user owns that appears on the 2nd user's wishlist
 #  @valid_trade is set to true if the 1st user has trade candidates, is false if not
  
  def set_valid_trade 
    user1_chars = user1.get_characters("user_id")
      user1_chars.each do |char|
       @user1_valid_chars << char if user2_wishlist.get_char_ids.include?(char.id)
      end
      if user1_valid_chars == []
        @valid_trade = false
      else @valid_trade = true
      end
  end
  
end# class end