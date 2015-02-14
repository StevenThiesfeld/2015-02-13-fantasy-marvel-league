require 'pry'
require 'sqlite3'
DATABASE = SQLite3::Database.new('database/f_m_l.db')
require 'marvelite'
require_relative "database/db_setup"
require_relative "database/database_methods"