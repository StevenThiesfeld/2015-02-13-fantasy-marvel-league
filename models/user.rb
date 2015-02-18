# Class: User
# A user of the Fantasy Marvel League
#
# Attributes:
# @id            - Integer: the user's id in the database
# @name          - String:  the user's user name
# @password      - String:  the user's password
# @image         - String:  the URL to the user's avatar
#Public Methods:
# #delete_user
# .login
# #user_setup
# #get_unassigned_chars

class User
  include DatabaseMethods
  extend ClassMethods
  include ModelHelper
  attr_reader :id
  attr_accessor :name, :password, :image
  
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @password = options["password"]
    @image = options["image"]
  end
  
  # Public Method: #delete_user
#   Deletes a user's profile and all table entries associated with his account.
#
#   Parameters: none
#
#   Returns: nil
#
#   State Changes:
#   Removes all entries from the database related to the user
  
  def delete_user
    DATABASE.execute("DELETE FROM characters WHERE user_id = #{@id}")
    DATABASE.execute("DELETE FROM teams WHERE user_id = #{@id}")
    DATABASE.execute("DELETE FROM wishlists WHERE user_id = #{@id}")
    DATABASE.execute("DELETE FROM users WHERE id = #{@id}")
  end
  
  # Public Method: .login
#   Checks that the entered username and password is valid, then creates the user
#   object.
#
#   Parameters:
#   params    - Hash: A hash containing name and password from the user
#
#   Returns:
#   user      - User: The current User object.
#
#   State Changes:
#   Sets user to the current User object.
  
  def self.login(params)
    user_info = DATABASE.execute("SELECT * FROM users WHERE name='#{params["name"]}' AND password='#{params["password"]}'")
    user = self.new(user_info[0]) if user_info[0] != nil
    user
  end
  
  # Public Method: #user_setup
 #  Creates a new wishlist and a new team for newly created users.
 #
 #  Parameters: none
 #
 #  Returns: none
 #
 #  State Changes: Inserts a new team and new wishlist to the database.
  
  def user_setup
    wishlist = Wishlist.new("name" => "Your Wishlist", "user_id" => @id)
    wishlist.insert("wishlists")
    team = Team.new("name" => "Your Team", "user_id" => @id)
    team.insert("teams")
  end
  
  # Public Method: #get_unassigned_chars
 #  Creates an array of the user's characters that aren't assigned to a team.
 #
 #  Parameters: none
 #
 #  Returns:
 #  unassigned_chars   - Array : An array of Character objects.
 #
 #  State Changes:
 #  Pushes every created object to unassigned_chars.
  
  def get_unassigned_chars
    unassigned_chars = []
    unassigned_array = DATABASE.execute("SELECT * FROM characters WHERE user_id = #{id} AND team_id = ''")
    unassigned_array.each do |char|
      unassigned_chars << Character.new(char) if char != nil
    end
    unassigned_chars
  end
      
end#class end