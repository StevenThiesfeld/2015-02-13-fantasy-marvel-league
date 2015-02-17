class Team
  include DatabaseMethods
  extend ClassMethods
  include ModelHelper
  
  attr_reader :id, :user_id
  attr_accessor :name
  
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @user_id = options["user_id"]
  end
  
  def delete
    chars = self.get_characters("team_id")
    chars.each do |char|
      char.team_id = ""
      char.save("characters")
    end
    DATABASE.execute("DELETE FROM teams WHERE id = #{id}")
  end
  
end#class end