# Class: Team
# A user's fictional team of Super Heroes
#
# Attributes:
# @id           - Integer: the team's primary key
# @name         - String:  the team's name
# @user_id      - Integer: the id of the table's owner
#
# Public Methods:
# #set_slug
# #error_check
# #delete

class Team < ActiveRecord::Base
  include ModelHelper
    
  after_initialize :defaults
  
  validates :name, presence: true
  
  has_many :characters
  belongs_to :user
  
  def defaults
    self.slug ||= set_slug
  end
  # Public Method: #set_slug
#   Sets the slug attribute to a URL friendly version of the name attribute
#
#   Parameters: none
#
#   Returns: @slug  - String: the formatted URL String
#
#   State Changes: @slug attribute is set to a String
  
  def set_slug
   user_id.to_s + "-" + name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
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
    errors[:name] = "Please Enter a Team Name" if name == ""
    errors
  end
  # Public Method: #delete
 #  deletes the and unassigns any character assigned to it
 #
 #  Parameters:none
 #
 #  Returns: self    the Team object acted upon
 #  State Changes:
 #  Changes the team_id of characters on the team to 0, and deletes the team from the table
  
  def delete
    self.characters.each do |char|
      char.update(team_id: 0)
    end
    self.destroy
    self
  end
  
end#class end