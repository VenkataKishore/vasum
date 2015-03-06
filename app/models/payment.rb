class Payment < ActiveRecord::Base
  belongs_to :user
  validates :amount, :user_id, :paid_at, presence: true
end
