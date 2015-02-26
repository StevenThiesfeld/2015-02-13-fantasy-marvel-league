DATABASE.results_as_hash = true

DATABASE.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY,
                  name TEXT UNIQUE NOT NULL, password TEXT NOT NULL, image TEXT)")
                  
DATABASE.execute("CREATE TABLE IF NOT EXISTS teams (id INTEGER PRIMARY KEY,
                 name TEXT NOT NULL, user_id INTEGER, slug TEXT UNIQUE,
                  FOREIGN KEY(user_id) REFERENCES users(id))")
                  
DATABASE.execute("CREATE TABLE IF NOT EXISTS characters (id INTEGER PRIMARY KEY,
 name TEXT UNIQUE NOT NULL, description TEXT, user_id INTEGER, team_id INTEGER, 
 image TEXT, popularity INTEGER, FOREIGN KEY(team_id) REFERENCES team(id),
   FOREIGN KEY(user_id) REFERENCES user(id))")
   
DATABASE.execute("CREATE TABLE IF NOT EXISTS wishlists (id INTEGER PRIMARY KEY,
 name TEXT NOT NULL, user_id INTEGER, offer TEXT, FOREIGN KEY(user_id) REFERENCES user(id))") 
 
 
DATABASE.execute("CREATE TABLE IF NOT EXISTS characters_to_wishlists 
(character_id INTEGER NOT NULL, wishlist_id INTEGER NOT NULL, FOREIGN KEY(wishlist_id) 
REFERENCES wishlists(id), FOREIGN KEY(character_id) REFERENCES characters(id))")

DATABASE.execute("CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY, 
body TEXT, from_user_id INTEGER NOT NULL, to_user_id INTEGER NOT NULL,
viewed TEXT, trade TEXT, offered_char INTEGER, requested_char INTEGER)")
  
        
        