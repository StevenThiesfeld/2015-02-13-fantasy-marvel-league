# Class: Message
# A short message sent from one user to another that may include a trade request
#
# Attributes:
# @id             -  Integer: the object's location in the messages table
# @body           - String:   the text being sent in the message
# @from_user_id   - Integer:  the id of the user sending the message
# @to_user_id     - Integer:  the id of the user recieving the message
# @viewed         - String:   indicates if the recipient has seen the message or not
# @trade          - String:   indicates if a trade request was included in the message
# @offered_char   - Integer:  the id of the character the sender has offered
# @requested_char - Integer:  the id of the character the sender wants from the recipient
#
# Public Methods:
# .get_unviewed_messages
# .get_all_messages
# #get_from_user_name
# #get_to_user_name
# #mark_as_viewed
# #get_offered_char_name
# #get_requested_char_name

class Message < ActiveRecord::Base
    include ModelHelper
  
  after_initialize :defaults
  
  def defaults
    self.body = "no message" if self.body == ""
    self.viewed ||= "no"
  end
  
  # Class Method: .get_unviewed_messages
#   returns an array of unviewed Messages were sent to a given user
#
#   Parameters:
#   user_id             - Integer: the id of the user the messages belong to
#
#   Returns:
#   results_as_objects  - Array: an array containing unviewed message objects
#
#   State Changes: none
  
  def self.unviewed_messages(user_id)
    self.find_by(viewed: "no", to_user_id: user_id)
  end
  
  # Class Method: .get_all_messages
 #  returns an array of all message objects the given user has recieved/sent
 #
 #  Parameters:
 #  user_id            - Integer: the id of the User the messages belong to
 #
 #  Returns:
 #  results_as_objects   - Array: an Array containing all message associated with a user
 #
 #  State Changes: none
  
  def self.all_messages(user_id)
    self.where("to_user_id = ? OR from_user_id = ?", user_id, user_id)
  end
  
  # Public Method: #get_from_user_name
 #  fetches the name of the sender
 #
 #  Parameters: none
 #
 #  Returns:
 #  name        - String: the name of the sender
 #
 #  State Changes: none
  
  def get_from_user_name
    result = User.find_by(id: from_user_id)
    result ? name = result.name : name = "deleted user"
    name
  end
  
  # Public Method: #get_to_user_name
 #  fetches the name of the recipient
 #
 #  Parameters: none
 #
 #  Returns:
 #  name        - String: the name of the recipient
 #
 #  State Changes: none
  
  def get_to_user_name
    result = User.find_by(id: to_user_id)
    result ? name = result.name : name = "deleted user"
    name
  end
  
  # Public Method: #mark_as_viewed
 #  changes the viewed attribute to 'yes' and updates the database
 #
 #  Parameters: none
 #
 #  Returns: self    - the Message object acted upon
 #
 #  State Changes:
 #  @viewed set to "yes" and column is updated in the messages table
 
  def mark_as_viewed
    self.update(viewed: "yes")
  end
  
  # Public Method: #get_offered_char_name
#   fetches the name of the offered character
#
#   Parameters: none
#
#   Returns:
#   name           - String: the name of the character
#
#   State Changes: none
  
  def get_offered_char_name
    Character.find(offered_char).name  
  end
  
  # Public Method: #get_requested_char_name
#   fetches the name of the requested character
#
#   Parameters: none
#
#   Returns:
#   name           - String: the name of the character
#
#   State Changes: none
  
  def get_requested_char_name
    Character.find(requested_char).name
  end
    
end#class end