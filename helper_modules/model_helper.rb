module ModelHelper
    
  # Public: #display_attributes
   # Returns the attributes of an object as a table.
   #
   # Parameters:
   # attributes              - Array: an array for the column headings      
   #
   # Returns:
   # Table -  String:  a detailed table for the object
   #
   # State changes:
   # creates a new row in table for each attribute of the object.
  
  def display_attributes
     attributes = []
     instance_variables.each do |i|
       # Example  :@name
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
 #
 #  Parameters: none
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
        result += "<li>#{char.name}---<a href='/unassign?id=#{char.id}'>Unassign</a></li>"
      else result += "<li>#{char.name}</li>"
      end
    end
    result
  end
  
end#module end