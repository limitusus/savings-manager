class Transaction < ApplicationRecord
  validates :accounted_on, presence: true
  validates :explanation, presence: true
  validates :transaction_type, presence:true
  validates :amount, presence: true
end
