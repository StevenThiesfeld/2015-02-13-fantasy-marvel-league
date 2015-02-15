class Wishlist
  include DatabaseMethods
  extend ClassMethods
  include ModelHelper
  
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @user_id = options["user_id"]
  end
  
  
  
end#class end