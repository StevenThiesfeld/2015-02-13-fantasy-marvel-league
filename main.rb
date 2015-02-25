require 'pry'
require 'sqlite3'
require 'marvelite'
require "sinatra"
DATABASE = SQLite3::Database.new("f_m_l.db")
require_relative "database/db_setup"
require_relative "helper_modules/main_helper"
require_relative "helper_modules/model_helper"
require_relative "models/model_db_methods"
require_relative "models/wishlist"
require_relative "models/user"
require_relative "models/team"
require_relative "models/character"
require_relative "models/message"
require_relative "lib/search_engine"
require_relative "lib/trade"
require_relative "controllers/user"
require_relative "controllers/character"
require_relative "controllers/teams"
require_relative "controllers/wishlist"
require_relative "controllers/message"
require_relative "controllers/search"
require_relative "controllers/trade"


enable :sessions
helpers MainHelper, ModelHelper