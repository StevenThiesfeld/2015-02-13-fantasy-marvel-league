# Class: User
# A user of the Fantasy Marvel League
#
# Attributes:
# @id            - Integer: the user's id in the database
# @name          - String:  the user's user name
# @password      - String:  the user's password

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
  
  def delete_user
    DATABASE.execute("DELETE FROM characters WHERE user_id = #{@id}")
    DATABASE.execute("DELETE FROM teams WHERE user_id = #{@id}")
    DATABASE.execute("DELETE FROM wishlists WHERE user_id = #{@id}")
    DATABASE.execute("DELETE FROM users WHERE id = #{@id}")
  end
  
  def self.login(params)
    user_info = DATABASE.execute("SELECT * FROM users WHERE name='#{params["name"]}' AND password='#{params["password"]}'")
    user = self.new(user_info[0]) if user_info[0] != nil
    user
  end
  
  def user_setup
    wishlist = Wishlist.new("name" => "Your Wishlist", "user_id" => @id)
    wishlist.insert("wishlists")
    team = Team.new("name" => "Your First Team", "user_id" => @id)
    team.insert("teams")
  end
  
  def get_unassigned_chars
    unassigned_chars = []
    unassigned_array = DATABASE.execute("SELECT * FROM characters WHERE user_id = #{id} AND team_id = ''")
    unassigned_array.each do |char|
      unassigned_chars << Character.new(char) if char != nil
    end
    unassigned_chars
  end
      
end#class end