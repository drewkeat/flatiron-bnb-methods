class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin, checkout)
    ci = Date.parse(checkin)
    co = Date.parse(checkout)
    self.listings.select {|l| l.available?(ci, co)}
  end
end
