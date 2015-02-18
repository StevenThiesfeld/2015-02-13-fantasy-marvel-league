# Module: MainHelper
# A collection of methods to help Sinatra's routes
#
# Public Methods:
# #partial
# #set_unassigned_chars
# #team_full?
# #char_taken?
# #make_wishlist_chars

module MainHelper
  
  # Public Method: partial
#   Populates a partial erb template with local variables
#
#   Parameters:
#   template     - ERB file: the partial erb file being called
#   locals       - Hash    : local information needed in the partial
#
#   Returns: none
#
#   State Changes: none
  
  def partial (template, locals = {})
    erb(template, :layout => false, :locals => locals)
  end
  
  # Public Method: #set_unassigned_chars
  # Sets an instance variable to an array of characters not assigned to a team
  #
  # Parameters: none
  # Returns: none
  # State Changes:
  # sets @unassigned_chars to an array of character objects

  def set_unassigned_chars
   @unassigned_chars = session[:user].get_unassigned_chars
  end
  
  # Public Method: #team_full?
 #  Checks if a team is at maximum capacity
 #
 #  Parameters:
 #  team      - Team:  the team object being checked
 #
 #  Returns:
 #  true if the team is at capacity
 #  false if there is room
 #
 #  State Changes: none

  def team_full?(team)
    if team.get_characters("team_id").length == 6
      true
    else false
    end
  end
  
  # Public Method: #char_taken?
 #  Checks if a character searched for is already claimed by another user
 #
 #  Parameters:
 #  char         - Character:  the character object created by the search engine
 #
 #  Returns:
 #  false if the character is available
 #  the user name of the user who has claimed the character
 #
 #  State Changes: none

  def char_taken?(char)
    check_char = Character.search_where("characters", "name", char.name)
    if check_char == [] 
      "no_entry"
    else
      if check_char[0].user_id == 0
        "unassigned"
      else
        user_name =  DATABASE.execute("SELECT name FROM users WHERE id = #{check_char[0].user_id}")[0]["name"]
        user_name
      end
    end
  end
  
  def fetch_id(char_name)
    char = Character.search_where("characters", "name", char_name)[0]
    id = char.id
    id
  end
  
  def display_wishlist(user)
    result = "<ul>"
    wishlist = Wishlist.search_where("wishlists", "user_id", user.id)[0]
    wishlist_chars = wishlist.set_wishlist_chars(user)
    wishlist_chars.each do |char|
      result += "<li>#{char.name}</li>"
    end
    result += "</ul><p>Currently Offering: #{wishlist.offer}</p>"
  end
  
  def all_teams(user_id)
    result = ""
    teams = Team.search_where("teams", "user_id", user_id)
    teams
  end
end#module end