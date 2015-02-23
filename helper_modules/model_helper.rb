# Module: ModelHelper
# A collection of methods to help models display their info to html
#
# Public Methods:
# #display_attributes
# #list_chars_in_team
# #display_wishlist

module ModelHelper
    
  # Public: #display_attributes
   # Returns the attributes of an object as a table.
   #
   # Parameters:
   # attributes              - Array: an array for the column headings      
   #
   # Returns:
   # Table -  String:  a table for the object
   #
   # State changes:
   # creates a new row in table for each attribute of the object.
  
  def display_attributes
     attributes = []
     instance_variables.each do |i|
       attributes << i.to_s.delete("@")
     end
    table = "<table><tr><th>FIELD</th><th>VALUE</th></tr>"
    attributes.each do |a|
      table += "<tr><td>#{a}</td><td>#{self.send(a)}</td></tr>"
    end
    table +="</table>"
    table
  end
  
  # Public Method: #list_chars_in_team
 #  Displays a list of Character names in a team with an option to unassign them
 #  Will display additional options if displaying the user's team
 #  Parameters: 
 #  check          - String: tells the method what version of list to display
 #
 #  Returns:
 #  result         - String: a formatted unordered list of characters
 #
 #  State Changes: none
 #
  
  def list_chars_in_team(check)
    result = ""
    chars_array = self.get_characters("team_id")
    chars_array.each do |char|
      if check == "user"
        result += "<tr><td>#{char.name}---<a href='/unassign?id=#{char.id}'>Unassign</a></td></tr>"
      else result += "<tr><td>#{char.name}</td></tr>"
      end
    end
    result
  end
  
  # Public Method: #display_wishlist
 #  Displays the wishlist of another user, and their offer
 #
 #  Parameters:
 #  user        - User: the user object the wishlist is gotten from
 #
 #  Returns:
 #  result      - String: an response formatted in html
 #
 #  State Changes: none
  
  def display_wishlist
    result = "<ul>"
    wishlist = Wishlist.search_where("wishlists", "user_id", id)[0]
    wishlist_chars = wishlist.set_wishlist_chars(self)
    wishlist_chars.each do |char|
      result += "<li>#{char.name}----Owned By: #{char.find_owner.name}</li>"
    end
    result += "</ul><p>Currently Offering: #{wishlist.offer}</p>"
    result
  end
  
end#module end