class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: :true
  validate :trip_ended, :reservation_accepted

  private
  
    def trip_ended
      unless self.reservation && self.reservation.checkout < Date.today
        errors.add(:reservation_id, "Stay must be complete before leaving a review.")
      end
    end

    def reservation_accepted
      unless self.reservation && self.reservation.status == "accepted"
        errors.add(:reservation_id, "This reservation was not accepted.")
      end
    end
end
