class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(checkin, checkout)
      ci = Date.parse(checkin)
      co = Date.parse(checkout)
      self.listings.select {|l| l.available?(ci, co)}
  end

  def self.most_res
    city_res = {}
    self.all.each do |city|
      count = city.reservations.count
      city_res[city] = count
    end
    city_res.sort.first.first
  end

  def self.highest_ratio_res_to_listings
    self.all.map {|city| [city, (city.reservations.count.to_f / city.listings.count.to_f)]}.to_h.sort.first.first
  end
end

