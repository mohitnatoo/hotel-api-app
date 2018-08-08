class PaymentTransaction < ApplicationRecord
  belongs_to :reservation

  validates_presence_of :reservation
  validates_presence_of :source_id
end
