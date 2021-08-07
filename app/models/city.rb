class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
      ci = Date.parse(checkin)
      co = Date.parse(checkout)
      self.listings.select {|l| l.available?(ci, co)}
  end

end

