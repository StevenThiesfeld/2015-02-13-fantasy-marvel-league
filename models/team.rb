# Class: Team
# A user's fictional team of Super Heroes
#
# Attributes:
# @id           - Integer: the team's primary key
# @name         - String:  the team's name
# @user_id      - Integer: the id of the table's owner
#
# Public Methods:
# #delete

class Team
  include DatabaseMethods
  extend ClassMethods
  include ModelHelper
  
  attr_reader :id, :user_id
  attr_accessor :name
  
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @user_id = options["user_id"]
  end
  
  # Public Method: #delete
 #  deletes the and unassigns any character assigned to it
 #
 #  Parameters:none
 #
 #  Returns: none
 #  State Changes:
 #  Edits each character assigned to the team, and deletes the team from the table
  
  def delete
    chars = self.get_characters("team_id")
    chars.each do |char|
      char.team_id = 0
      char.save("characters")
    end
    DATABASE.execute("DELETE FROM teams WHERE id = #{id}")
  end
  
end#class end