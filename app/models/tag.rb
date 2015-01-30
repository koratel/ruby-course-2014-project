class Tag < ActiveRecord::Base
  belongs_to :problem
  validates :name, presence: true, length: { maximum: 50 }
end
