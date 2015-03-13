require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'bcrypt'
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
require_relative "models/characterswishlist"
require_relative "lib/search_engine"
require_relative "lib/trade"
require_relative "controllers/user"
require_relative "controllers/characters"
require_relative "controllers/teams"
require_relative "controllers/wishlist"
require_relative "controllers/messages"
require_relative "controllers/search"
require_relative "controllers/trade"
configure :development do
  set :database, {adapter: "sqlite3", database: "f_m_l.db"}
end

configure :production do
 db = URI.parse(ENV['DATABASE_URL'])
 ActiveRecord::Base.establish_connection(
 :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
 :host => db.host,
 :username => db.user,
 :password => db.password,
 :database => db.path[1..-1],
 :encoding => 'utf8'
 )
end

enable :sessions
helpers MainHelper, ModelHelper
