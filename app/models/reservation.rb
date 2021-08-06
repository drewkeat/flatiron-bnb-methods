class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * self.duration
  end
end
