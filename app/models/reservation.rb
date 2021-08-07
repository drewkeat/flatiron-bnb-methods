class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  
  validate :checkout_after_checkin, :not_host, :available
  validates :checkin, :checkout, presence: true


  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * self.duration
  end

  private

    def checkout_after_checkin
      return if checkout.blank? || checkin.blank?
      
      if checkout < checkin || checkout == checkin
        errors.add(:checkout, "must be after the checkin") 
      end 
    end

    def not_host
      if self.listing.host == self.guest
        errors.add(:guest_id, "You cannot reserve your own listing.")
      end
    end

    def available
      return if checkout.blank? || checkin.blank?

      unless self.listing.available?(self.checkin, self.checkout)
        errors.add(:checkin, "This listing isn't available for these dates.")
      end
    end

end
