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

class User < ActiveRecord::Base
  # include DatabaseMethods
#   extend ClassMethods
  include ModelHelper
  
  after_initialize :defaults

  def defaults
    self.image = "http://shackmanlab.org/wp-content/uploads/2013/07/person-placeholder.jpg" if self.image == ""
  end
  
  has_many :characters
  has_many :teams
  has_one :wishlist
#   # Public Method: #delete_user
# #   Deletes a user's profile and all table entries associated with his account.  Changes the user id and team id of user's characters to 0
# #
# #   Parameters: none
# #
# #   Returns: self    - the User object acted upon
# #
# #   State Changes:
# #   Removes all entries from the database related to the user and clears character assignments
#
  def delete_user
    self.wishlist.destroy
    DATABASE.execute("DELETE FROM teams WHERE user_id = #{id}")
    self.characters.each do |char|
      char.update(team_id: 0, user_id: 0)
    end
    self.destroy
    self
  end
#

#   # Public Method: #user_setup
#  #  Creates a new wishlist and a new team for newly created users.
#  #
#  #  Parameters: none
#  #
#  #  Returns: self  - the User object acted upon
#  #
#  #  State Changes: Inserts a new team and new wishlist to the database.
#
  def user_setup
    wishlist = Wishlist.create("name" => "Your Wishlist", "user_id" => @id)
    team = Team.create("name" => "Your Team", "user_id" => @id)
    self
  end
#
      
end#class end