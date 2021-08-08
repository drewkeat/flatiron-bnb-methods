class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: :true
  
  before_create do
    unless self.host.host == true
      self.host.update(host: !self.host.host)
    end
  end

  before_destroy :remove_host

  def available?(checkin, checkout)
    self.reservations.each do |reservation|
      if (checkin <= reservation.checkout) && (checkout >= reservation.checkin)
        return false
      end
    end
    true
  end

  def average_review_rating
    self.reviews.average(:rating)
  end
  private

    def remove_host
      if self.host.listings.size == 1
        self.host.update(host: false)
      end
    end
end
