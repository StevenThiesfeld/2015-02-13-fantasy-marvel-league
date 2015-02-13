DATABASE.results_as_hash = true

DATABASE.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY,
                  name TEXT UNIQUE NOT NULL, password TEXT NOT NULL)")
                  
DATABASE.execute("CREATE TABLE IF NOT EXISTS teams (id INTEGER PRIMARY KEY,
                 name TEXT NOT NULL, user_id INTEGER, FOREIGN KEY(user_id) REFERENCES users(id))")
                  
DATABASE.execute("CREATE TABLE IF NOT EXISTS characters (id INTEGER PRIMARY KEY,
 name TEXT UNIQUE NOT NULL, description TEXT, user_id INTEGER, team_id INTEGER, 
 image TEXT, popularity INTEGER, FOREIGN KEY(team_id) REFERENCES team(id),
   FOREIGN KEY(user_id) REFERENCES user(id))")
        
        