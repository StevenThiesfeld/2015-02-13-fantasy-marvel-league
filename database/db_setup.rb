unless ActiveRecord::Base.connection.table_exists?(:users)
  ActiveRecord::Base.connection.create_table :users do |t|
    t.text :name
    t.text :password
    t.text :image
  end
end

# DATABASE.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY,
#                   name TEXT UNIQUE NOT NULL, password TEXT NOT NULL, image TEXT)")

unless ActiveRecord::Base.connection.table_exists?(:teams)
  ActiveRecord::Base.connection.create_table :teams do |t|
    t.text :name
    t.integer :user_id
    t.text :slug
  end
end
                  
# DATABASE.execute("CREATE TABLE IF NOT EXISTS teams (id INTEGER PRIMARY KEY,
#                  name TEXT NOT NULL, user_id INTEGER, slug TEXT UNIQUE,
#                   FOREIGN KEY(user_id) REFERENCES users(id))")
                 
unless ActiveRecord::Base.connection.table_exists?(:characters)
  ActiveRecord::Base.connection.create_table :characters do |t|
    t.text :name                 
    t.text :description
    t.integer :user_id
    t.integer :team_id
    t.text :image
    t.integer :popularity
  end
end
                  
# DATABASE.execute("CREATE TABLE IF NOT EXISTS characters (id INTEGER PRIMARY KEY,
#  name TEXT UNIQUE NOT NULL, description TEXT, user_id INTEGER, team_id INTEGER,
#  image TEXT, popularity INTEGER, FOREIGN KEY(team_id) REFERENCES team(id),
#    FOREIGN KEY(user_id) REFERENCES user(id))")

unless ActiveRecord::Base.connection.table_exists?(:wishlists)
  ActiveRecord::Base.connection.create_table :wishlists do |t|
    t.text :name
    t.integer :user_id
    t.text :offer
  end
end
   
# DATABASE.execute("CREATE TABLE IF NOT EXISTS wishlists (id INTEGER PRIMARY KEY,
#  name TEXT NOT NULL, user_id INTEGER, offer TEXT, FOREIGN KEY(user_id) REFERENCES user(id))")
#
 
unless ActiveRecord::Base.connection.table_exists?(:characters)
  ActiveRecord::Base.connection.create_table :characters do |t|
    t.integer :character_id
    t.integer :wishlist_id
  end
end
 
# DATABASE.execute("CREATE TABLE IF NOT EXISTS characters_wishlists
# (character_id INTEGER NOT NULL, wishlist_id INTEGER NOT NULL, FOREIGN KEY(wishlist_id)
# REFERENCES wishlists(id), FOREIGN KEY(character_id) REFERENCES characters(id))")

unless ActiveRecord::Base.connection.table_exists?(:characters)
  ActiveRecord::Base.connection.create_table :characters do |t|
    t.text :body
    t.integer :from_user_id
    t.integer :to_user_id
    t.text :viewed
    t.text :trade
    t.integer :offered_char
    t.integer :requested_char
  end
end

# DATABASE.execute("CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY,
# body TEXT, from_user_id INTEGER NOT NULL, to_user_id INTEGER NOT NULL,
# viewed TEXT, trade TEXT, offered_char INTEGER, requested_char INTEGER)")
  
        
        