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
  include DatabaseMethods
  extend ClassMethods
  include ModelHelper
  
  attr_reader :id, :user_id, :slug
  attr_accessor :name
  
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @user_id = options["user_id"]
    options["slug"] ? @slug = options["slug"] : set_slug  
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
    @slug = name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
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
    chars = self.get_characters("team_id")
    chars.each do |char|
      char.team_id = 0
      char.save("characters")
    end
    DATABASE.execute("DELETE FROM teams WHERE id = #{id}")
    self
  end
  
end#class end