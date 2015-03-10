# Class: Character
# A comic book character pulled from Marvel's API database
#
# Attributes:
# @id           - Integer: The primary key of the object's table
# @name         - String : The Character's name
# @description  - String : A short biography of the character
# @user_id      - Integer: The user id that the character is assigned to
# @team_id      - Integer: The team id that the character is assigned to
# @image        - String:  A URL to an image of the character
# @popularity   - Integer: The number of comics the character appears in
#
# Public Methods:
# #find_owner

class Character < ActiveRecord::Base
  include DatabaseMethods
  extend ClassMethods
  include ModelHelper
  
  attr_reader :id, :name, :description, :image, :popularity
  attr_accessor :user_id, :team_id
  
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @description = options["description"]
    @user_id = options["user_id"]
    @team_id = options["team_id"]
    options["image"] != nil ? @image = options["image"] : @image = "http://cdn-static.denofgeek.com/sites/denofgeek/files/styles/article_main_half/public/images/86941.jpg?itok=xEKeqXcW"
    @popularity = options["popularity"]
  end
  
  # Public Method: #find_owner
#   returns the user object the character is assigned to
#
#   Parameters: none
#
#   Returns:
#   owner      - User: the user the character is assigned to
#
#   State Changes: none
  
  def find_owner
    owner = User.find("users", user_id) 
    owner
  end
  
end#class end  