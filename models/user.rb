# Class: User
# A user of the Fantasy Marvel League
#
# Attributes:
# @id            - Integer: the user's id in the database
# @name          - String:  the user's user name
# @password      - String:  the user's password

class User
  attr_reader :id
  attr_accessor :name, :password
  
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @password = options["password"]
  end
  
  def delete_user
    DATABASE.execute("DELETE FROM characters WHERE user_id = #{@id}")
    DATABASE.execute("DELETE FROM teams WHERE user_id = #{@id}")
    DATABASE.execute("DELETE FROM wishlist WHERE user_id = #{@id}")
    DATABASE.execute("DELETE FROM users WHERE id = #{@id}")
  end
  
  
end#class end