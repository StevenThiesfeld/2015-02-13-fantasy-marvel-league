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
  include DatabaseMethods
  extend ClassMethods
  include ModelHelper
  
  attr_reader :from_user_id, :to_user_id, :body, :id, :offered_char,
  :requested_char
  attr_accessor :viewed, :trade
  
  def initialize(options)
    @id = options["id"]
    options["body"] == "" ? @body = "no message" : @body = options["body"]
    @from_user_id = options["from_user_id"]
    @to_user_id = options["to_user_id"]
    options["viewed"] ? @viewed = options["viewed"] : @viewed = "no"
    @trade = options["trade"]
    @offered_char = options["offered_char"]
    @requested_char = options["requested_char"]
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
  
  def self.get_unviewed_messages(user_id)
    results = DATABASE.execute("SELECT * FROM messages WHERE viewed = 'no' AND 
    to_user_id = #{user_id}")
    results_as_objects(results)
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
  
  def self.get_all_messages(user_id)
    results = DATABASE.execute("SELECT * FROM messages WHERE to_user_id = #{user_id}
    OR from_user_id = #{user_id}")
    results_as_objects(results)
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
    result = DATABASE.execute("SELECT name FROM users WHERE id = #{from_user_id}")
    result != [] ? name = result[0]["name"] : name = "deleted user"
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
    result = DATABASE.execute("SELECT name FROM users WHERE id = #{to_user_id}")
    result != [] ? name = result[0]["name"] : name = "deleted user"
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
    @viewed = "yes"
    self.save("messages")
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
    name = DATABASE.execute("SELECT name FROM characters WHERE id = #{offered_char}")[0]["name"]  
    name
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
    name = DATABASE.execute("SELECT name FROM characters WHERE id = #{requested_char}")[0]["name"]  
    name
  end
    
end#class end