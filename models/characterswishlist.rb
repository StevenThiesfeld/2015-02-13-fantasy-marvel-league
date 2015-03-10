class CharactersWishlist < ActiveRecord::Base
  belongs_to :character
  belongs_to :wishlist
end