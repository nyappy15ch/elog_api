class Score < ApplicationRecord
  validates :franse_score, :germany_score, :pk_franse_score, :pk_germany_score, presence: true
end
