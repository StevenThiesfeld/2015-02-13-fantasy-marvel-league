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
  include ModelHelper
  
  after_initialize :defaults
  
  def defaults
    self.image ||= "http://cdn-static.denofgeek.com/sites/denofgeek/files/styles/article_main_half/public/images/86941.jpg?itok=xEKeqXcW"
  end
  belongs_to :user
  belongs_to :team
  has_many :characters_wishlists
  has_many :wishlists, :through => :characters_wishlists

end#class end  