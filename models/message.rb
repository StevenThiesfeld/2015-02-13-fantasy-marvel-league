class Message
  
  def initialize(options)
    @id = options["id"]
    @body = options["body"]
    @from_user_id = options["from_user_id"]
    @to_user_id = options["to_user_id"]
    @viewed = options["viewed"]
  end