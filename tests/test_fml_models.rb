require 'sqlite3'
require 'pry'
DATABASE = SQLite3::Database.new('../test_f_m_l.db')
require 'minitest/autorun'
require 'marvelite'
require_relative "../database/db_setup"
require_relative "../models/model_db_methods"
require_relative "../helper_modules/model_helper"
require_relative "../helper_modules/main_helper"
require_relative "../models/user"
require_relative "../models/character"
require_relative "../models/team"
require_relative "../models/wishlist"
require_relative "../models/search_engine"
require_relative "../models/trade"



class TestModels < Minitest::Test
  include DatabaseMethods
  extend ClassMethods
  
  def setup
    DATABASE.execute("DELETE FROM users")
    DATABASE.execute("DELETE FROM characters")
    DATABASE.execute("DELETE FROM teams")
    DATABASE.execute("DELETE FROM wishlists")
    DATABASE.execute("DELETE FROM characters_to_wishlists")
  end
  
  def test_simple_thing
    assert_equal(1, 1)
  end
  
  #USER TESTS-------------------------------------------------------------------
  def test_login  #test passes
    user = User.new("name" => "test", "password" => "password")
    user.insert("users")
    refute_equal(user, User.login("name" => "test1", "password" => "password"))
    assert_equal(user.name, User.login("name" => "test", "password" => "password").name)
  end
  
  def test_user_setup  #test pass
    user = User.new("name" => "setup_test", "password" => "password")
    user.insert("users")
    user.user_setup
    wishlist_check = DATABASE.execute("SELECT * FROM wishlists WHERE user_id=#{user.id}")
    refute_equal([], wishlist_check)
    team_check = DATABASE.execute("SELECT * FROM teams WHERE user_id=#{user.id}")
    refute_equal([], team_check)
  end
  
  def test_get_unassigned_chars #test pass
    user = User.new("name" => "char_test", "password" => "password")
    user.insert("users")
    char = Character.new("name" => "test", "user_id" => user.id, "team_id" => 1)
    char.insert("characters")
    char2 = Character.new("name" => "test2", "user_id" => user.id, "team_id" => 0)
    char2.insert("characters")
    check = user.get_unassigned_chars
    assert_equal("test2", check[0].name)
  end
  
  def test_all_teams #test pass
    user = User.new("name" => "allteam_test", "password" => "password")
    user.insert("users")
    team1 = Team.new("name" => "allteam1", "user_id" => user.id)
    team2 = Team.new("name" => "allteam2", "user_id" => user.id)
    team1.insert("teams")
    team2.insert("teams")
    assert_equal(2, user.all_teams.length)
  end

  #-----------------------------------------------------------------------------
  #WISHLIST TESTS---------------------------------------------------------------
  def test_add_to_wishlist #test pass
    wishlist = Wishlist.new("name" => "testlist")
    wishlist.insert("wishlists")
    wishlist.add_to_wishlist(1)
    check = DATABASE.execute("SELECT * FROM characters_to_wishlists WHERE
     character_id=1 AND wishlist_id=#{wishlist.id}")
     refute_equal([], check)
   end
   
   def test_set_wishlist_chars #test pass
     user = User.new("name" => "wishlist_test", "password" => "password")
     user.insert("users")
     wishlist = Wishlist.new("name" => "testlist", "user_id" => user.id)
     wishlist.insert("wishlists")
     char = Character.new("name" => "wishlist_test", "user_id" => user.id, "team_id" => 1)
     char2 = Character.new("name" => "wishlist_test2", "user_id" => 0, "team_id" => 1)
     char2.insert("characters")
     char.insert("characters")
     wishlist.add_to_wishlist(char.id)
     wishlist.add_to_wishlist(char2.id)
     check = wishlist.set_wishlist_chars
     assert_kind_of(Character, check[0])
     assert_equal(1, check.length)
   end
   
   def test_check_offer #test pass
     user = User.new("name" => "offer_test", "password" => "password")
     user.insert("users")
     wishlist = Wishlist.new("name" => "testlist", "offer" => "this shouldn't be here")
     wishlist.insert("wishlists")
     wishlist.check_offer
     assert_equal("", wishlist.offer)
   end
     
   #----------------------------------------------------------------------------
   #TEAM TESTS------------------------------------------------------------------
   def test_delete #test pass
     DATABASE.execute("DELETE FROM teams")
     team = Team.new("name" => "teamtest")
     team.insert("teams")
     char = Character.new("name" => "test", "team_id" => team.id)
     char.insert("characters")
     team.delete
     assert_equal([], DATABASE.execute("SELECT * FROM teams"))
     assert_equal([], DATABASE.execute("SELECT * FROM characters WHERE team_id=1"))
   end
   #----------------------------------------------------------------------------
   #SEARCH ENGINE TESTS---------------------------------------------------------
   def test_search_for_chars #test pass
     test = SearchEngine.new("user_search" => "Spider-Man")
     char = test.search_for_chars[0]
     assert_kind_of(Character, char)
     assert_equal("Spider-Man", char.name)
   end
   
   #----------------------------------------------------------------------------
   #TRADE TESTS-----------------------------------------------------------------
   def test_trade
     user1 = User.new("name" => "trade_test1", "password" => "password")
     user2 = User.new("name" => "trade_test2", "password" => "password")
     user1.insert("users")
     user2.insert("users")
     wishlist = Wishlist.new("name" => "testlist", "user_id" => user2.id)
     wishlist.insert("wishlists")
     trade = Trade.new("user1" => user1, "user2" => user2)
     assert_equal(false, trade.valid_trade)
   end
     
end#class end

class TestDatabaseModule < Minitest::Test
  
  def setup
    DATABASE.execute("DELETE FROM users")
    DATABASE.execute("DELETE FROM characters")
    DATABASE.execute("DELETE FROM teams")
    DATABASE.execute("DELETE FROM wishlists")
    DATABASE.execute("DELETE FROM characters_to_wishlists")
  end
  
  def test_insert
    t = User.new("name" => "D'hargo", "password" => "p'a's's'w'o'r'd")
    t.insert("users")
    test = DATABASE.execute("SELECT * FROM users")
  end
  
end#class end




