class Match < ApplicationRecord
  belongs_to :matchable, polymorphic: true
end
