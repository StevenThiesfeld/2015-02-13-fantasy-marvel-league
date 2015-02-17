module MainHelper
  
    def partial (template, locals = {})
      erb(template, :layout => false, :locals => locals)
    end
    
    def set_unassigned_chars
     @unassigned_chars = session[:user].get_unassigned_chars
    end
    
    def team_full?(team)
      if team.get_characters("team_id").length == 6
        true
      else false
      end
    end
    
    def char_taken?(char)
      check_char = Character.search_where("characters", "name", char.name)
      if check_char == []
        false
      else user_name =  DATABASE.execute("SELECT name FROM users WHERE id = #{check_char[0].user_id}")[0]["name"]
        user_name
      end
    end
    
    def make_wishlist_chars(chars)
      results = []
      chars.each do |char|
        results << Character.find("characters", char["character_id"])
      end
      results
    end
end#module end