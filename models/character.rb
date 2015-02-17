class Character
  include DatabaseMethods
  extend ClassMethods
  include ModelHelper
  
  attr_reader :id, :name, :description, :image, :popularity
  attr_accessor :user_id, :team_id
  
  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @description = options["description"]
    @user_id = options["user_id"]
    @team_id = options["team_id"]
    options["image"] != nil ? @image = options["image"] : @image = "http://cdn-static.denofgeek.com/sites/denofgeek/files/styles/article_main_half/public/images/86941.jpg?itok=xEKeqXcW"
    @popularity = options["popularity"]
  end
  
end#class end  