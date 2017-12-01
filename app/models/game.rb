class Game < ApplicationRecord
  belongs_to :article
  has_many :matches, as: :matchable
end
