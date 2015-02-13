require 'sqlite3'
require 'pry'
DATABASE = SQLite3::Database.new('database/test_warehouse_database.db')
require 'minitest/autorun'
require_relative "../database/database_methods"
require_relative "../helper_modules/model_helper"
require_relative '../database/db_setup'
require_relative '../models/search_engine'
require_relative '../models/user'