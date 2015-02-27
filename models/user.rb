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
# #get_wishlist

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
    @image = "http://shackmanlab.org/wp-content/uploads/2013/07/person-placeholder.jpg" if options["image"] == ""
  end
  
  # Public Method: error_check
#   Checks the attributes that are inputted by the user for errors.
#
#   Parameters: none
#
#   Returns: errors   - Hash: a Hash containing all errors the user has made
#
#   State Changes: none
  
  def error_check
    errors = {}
    errors[:name] = "Please Enter a User Name" if name == ""
    errors[:taken] = "That User Name is already taken" if DATABASE.execute("SELECT * FROM users WHERE name = '#{name}'")[0]
    errors[:password] = "Please Enter a Password" if password == ""
    errors
  end
  
  # Public Method: #delete_user
#   Deletes a user's profile and all table entries associated with his account.  Changes the user id and team id of user's characters to 0
#
#   Parameters: none
#
#   Returns: self    - the User object acted upon
#
#   State Changes:
#   Removes all entries from the database related to the user and clears character assignments
  
  def delete_user
    wishlist = Wishlist.search_where("wishlists", "user_id", id)[0]
    wishlist.delete_wishlist
    DATABASE.execute("DELETE FROM teams WHERE user_id = #{id}")
    self.get_characters("user_id").each do |char|
      char.team_id = 0
      char.user_id = 0
      char.save("characters")
    end
    DATABASE.execute("DELETE FROM users WHERE id = #{id}")
    self
  end
  
  # Public Method: .login
#   Checks that the entered username and password is valid, then creates the user
#   object.
#
#   Parameters:
#   params    - Hash: A hash containing name and password from the user
#
#   Returns:
#   user      - User: The current User object or nil if the login info is invalid
#
#   State Changes:
#   Sets user to the current User object.
  
  def self.login(params)
    user_info = DATABASE.execute("SELECT * FROM users WHERE name='#{params["name"]}' AND password='#{params["password"]}'")
    user = self.new(user_info[0]) if user_info[0]
    user
  end
  
  # Public Method: #user_setup
 #  Creates a new wishlist and a new team for newly created users.
 #
 #  Parameters: none
 #
 #  Returns: self  - the User object acted upon
 #
 #  State Changes: Inserts a new team and new wishlist to the database.
  
  def user_setup
    wishlist = Wishlist.new("name" => "Your Wishlist", "user_id" => @id)
    wishlist.insert("wishlists")
    team = Team.new("name" => "Your Team", "user_id" => @id)
    team.insert("teams")
    self
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
    unassigned_array = DATABASE.execute("SELECT * FROM characters WHERE user_id = #{id} AND team_id = 0")
    unassigned_array.each do |char|
      unassigned_chars << Character.new(char) if char != nil
    end
    unassigned_chars
  end
  
  # Public Method: #get_wishlist
 #  Returns the wishlist that belongs to the user
 #
 #  Parameters: none
 #
 #  Returns:
 #  wishlist        - Wishlist the wishlist object assigned to the user
 #
 #  State Changes: none
  
  def get_wishlist
    wishlist = Wishlist.search_where("wishlists", "user_id", id)[0]
    wishlist
  end
      
end#class end