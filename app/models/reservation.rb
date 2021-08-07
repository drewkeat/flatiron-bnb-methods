class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  
  validate :checkout_after_checkin
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

end
