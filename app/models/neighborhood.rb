class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(checkin, checkout)
    ci = Date.parse(checkin)
    co = Date.parse(checkout)
    self.listings.select {|l| l.available?(ci, co)}
  end

  def self.most_res
    nbrhd_res = {}
    self.all.each do |nbrhd|
      count = nbrhd.reservations.count
      nbrhd_res[nbrhd] = count
    end
    nbrhd_res.sort.first.first
  end

  def self.highest_ratio_res_to_listings
    self.all.map {|nbrhd| [nbrhd, (nbrhd.reservations.count.to_f / nbrhd.listings.count.to_f)]}.to_h.sort.first.first
  end
end
