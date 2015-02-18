class Trade
  
  attr_reader :valid_trade
  attr_accessor :user1, :user2, :user2_char, :user1_valid_chars
  
  def initialize(options)
    @user1 = options["user1"]
    @user2 = options["user2"]
    @user2_wishlist = Wishlist.search_where("wishlists", "user_id", @user2.id)[0]
    @user1_valid_chars = []
    set_user2_char
    set_valid_trade
  end
  
  private
  def set_user2_char
    char_name = @user2_wishlist.offer
    @user2_char = Character.search_where("characters", "name", char_name)[0]
  end
  
  def set_valid_trade
    user1_chars = @user1.get_characters("user_id")
    valid_ids =  DATABASE.execute("SELECT character_id FROM characters_to_wishlists WHERE wishlist_id = #{@user2_wishlist.id}")[0] 
    if valid_ids != nil
      user1_chars.each do |char|
       @user1_valid_chars << char if valid_ids.has_value?(char.id)
      end
      if @user1_valid_chars == []
        @valid_trade = false
      else @valid_trade = true
      end
    else @valid_trade = false
    end
  end
  
end# class end