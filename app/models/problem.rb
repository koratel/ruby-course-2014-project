class Problem < ActiveRecord::Base
  belongs_to :user
  has_many :tags, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }

  accepts_nested_attributes_for :tags, :reject_if => :all_blank, :allow_destroy => true
end
