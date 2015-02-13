require 'pry'

# Class: User
# A user of the Fantasy Marvel League
#
# Attributes:
# @id            - Integer: the user's id in the database
# @name          - String:  the user's user name
# @password      - String:  the user's password

class User
  
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @password = options["password"]
  end
  
  def change_name
    
  
  
end#class end