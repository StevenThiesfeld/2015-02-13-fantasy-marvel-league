# Module: MainHelper
# A collection of methods to help Sinatra's routes
#
# Public Methods:
# #partial
# #team_full?
# #char_taken?
# #fetch_id
# #make_trade
# #display_trade_option?

module MainHelper
  
  # Public Method: partial
#   Populates a partial erb template with local variables
#
#   Parameters:
#   template     - ERB file: the partial erb file being called
#   locals       - Hash    : local information needed in the partial
#
#   Returns: the contents of the erb file
#
#   State Changes: none
  
  def partial (template, locals = {})
    erb(template, :locals => locals)
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
    if team.characters.length == 6
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
 #  "no_entry" if the character doesn't exist in the local database
 #  "unassigned" if it exists in the database but isn't assigned to a user
 #  user_name: the user name of the user who has claimed the character
 #
 #  State Changes: none

  def char_taken?(char)
    check_char = Character.find_by(name: char.name)
    if check_char == nil 
      "no_entry"
    else
      if check_char.user_id == 0
        "unassigned"
      else
        check_char.user.name
      end
    end
  end
  
  # Public Method: #fetch_id
 #  will return the id of a character based on their name
 #
 #  Parameters:
 #  char_name          - String: the character's name to find the id for
 #
 #  Returns:
 #  id                 - Integer: the character's id number
 #
 #  State Changes: none
  
  def fetch_id(char_name)
    char = Character.find_by(name: char_name)
    char.id
  end
  
  # Public Method: #make_trade
#   Trades two characters between two users
#
#   Parameters:
#   params     -   Hash: Contains user1_id, user2_id, char1_id and char2_id
#   params contains message_id if the trade was done through a message
#
#   Returns: the 2nd saved Character object or the Message object
#
#   State Changes:
#   Edits and saves the character objects to their new users.
#   Will set a message's "trade" attribute to "finished" if relevant
  
  def make_trade(params)
    char1 = Character.find(params["char1_id"])
    char2 = Character.find(params["char2_id"])
    char1.update("team_id" => 0, "user_id" => params["user2_id"])
    char2.update("team_id" => 0, "user_id" => session[:user].id)
    if params["message_id"] != nil
      message = Message.find(params["message_id"])
      message.update(trade: "finished")
    end
  end
  
  # Public Method: display_trade_option?
#   Detirmines if a trade link should be displayed
#
#   Parameters:
#   user           - User: the user object being compared to the session user
#
#   Returns:
#   true if there is a valid trade option, false if there is not
#
#   State Changes: none
  
  def display_trade_option?(user)
    trade = Trade.new("user1" => session[:user], "user2" => user)
    trade.valid_trade
  end
  
end#module end