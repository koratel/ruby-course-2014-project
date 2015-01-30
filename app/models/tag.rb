class Tag < ActiveRecord::Base
  belongs_to :problem
  validates :problem_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
end
