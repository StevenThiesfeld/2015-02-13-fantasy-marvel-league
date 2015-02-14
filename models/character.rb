class Character
  include DatabaseMethods
  extend ClassMethods
  
  attr_reader :id, :name, :description, :image, :popularity
  attr_accessor :user_id, :team_id
  
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @description = options["description"]
    @user_id = options["user_id"]
    @team_id = options["team_id"]
    @image = options["image"]
    @popularity = options["popularity"]
  end
  
  
end#class end  