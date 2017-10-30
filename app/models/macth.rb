class Macth < ApplicationRecord
  belongs_to :macthable, polymorphic: true
end
