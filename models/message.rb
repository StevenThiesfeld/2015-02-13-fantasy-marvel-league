class Message
  include DatabaseMethods
  extend ClassMethods
  include ModelHelper
  
  attr_reader :from_user_id, :to_user_id, :body, :id
  attr_accessor :viewed
  
  def initialize(options)
    @id = options["id"]
    @body = options["body"]
    @from_user_id = options["from_user_id"]
    @to_user_id = options["to_user_id"]
    @viewed = options["viewed"]
    @viewed = "no" if options["viewed"] == nil
  end
  
  def self.get_unviewed_messages(user_id)
    results = DATABASE.execute("SELECT * FROM messages WHERE viewed = 'no' AND 
    to_user_id = #{user_id}")
    results_as_objects(results)
  end
  
  def self.get_all_messages(user_id)
    results = DATABASE.execute("SELECT * FROM messages WHERE to_user_id = #{user_id}
    OR from_user_id = #{user_id}")
    results_as_objects(results)
  end
  
  def get_sender_name
    sender = DATABASE.execute("SELECT name FROM users WHERE id = #{from_user_id}")[0]["name"]
    sender
  end
  
  def get_to_name
    recieved = DATABASE.execute("SELECT name FROM users WHERE id = #{to_user_id}")[0]["name"]
    recieved
  end
  
  def mark_as_viewed
    @viewed = "yes"
    self.save("messages")
  end
    
  
end#class end