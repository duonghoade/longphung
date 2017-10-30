class Game < ApplicationRecord
  belongs_to :article
  has_many :macths, as: :macthable
end
