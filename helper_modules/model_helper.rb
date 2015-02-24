# Module: ModelHelper
# A collection of methods to help models display their info to html
#
# Public Methods:
# #display_attributes

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
  
end#module end