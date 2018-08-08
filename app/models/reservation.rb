class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :payment_transactions

  validates_presence_of :user
  validates_presence_of :room
  validate :start_date_less_than_end_date

  scope :in_date_range, ->(start_date, end_date) { where("(start_date >= ? AND start_date <= ?) OR (start_date <= ? AND end_date >= ?)",
                                                         start_date, end_date, start_date, start_date) }

  private

    def start_date_less_than_end_date
      if start_date > end_date
        errors.add(:start_date, "Start date has to be less than end date")
      end
    end
end
