DATABASE.results_as_hash = true

DATABASE.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY,
                  name TEXT UNIQUE NOT NULL, password TEXT NOT NULL)")
                  
DATABASE.execute("CREATE TABLE IF NOT EXISTS teams (id INTEGER PRIMARY KEY,
                 name TEXT NOT NULL, user_id INTEGER, FOREIGN KEY(user_id) REFERENCES users(id))")
                  
DATABASE.execute("CREATE TABLE IF NOT EXISTS characters (id INTEGER PRIMARY KEY,
 name TEXT UNIQUE NOT NULL, description TEXT, user_id INTEGER, team_id INTEGER, 
 image TEXT, popularity INTEGER, FOREIGN KEY(team_id) REFERENCES team(id),
   FOREIGN KEY(user_id) REFERENCES user(id))")
   
DATABASE.execute("CREATE TABLE IF NOT EXISTS wishlists (id INTEGER PRIMARY KEY,
 name TEXT NOT NULL, user_id INTEGER, offer TEXT, FOREIGN KEY(user_id) REFERENCES user(id))") 
 
 
DATABASE.execute("CREATE TABLE IF NOT EXISTS characters_to_wishlists 
(wishlist_id INTEGER NOT NULL, character_id INTEGER NOT NULL, FOREIGN KEY(wishlist_id) 
REFERENCES wishlists(id), FOREIGN KEY(character_id) REFERENCES characters(id))")  
        
        