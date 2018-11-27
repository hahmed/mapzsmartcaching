require "pr_geohash"

class Venue < ApplicationRecord
  geocoded_by :address
  # get the country from geocoder, then we can use the cache_geohash method to save country in cache
  # using the geohash
  after_validation :geocode

  validates :address, presence: true

  before_save :cache_geohash

  def self.find_country_using_geohash_from_cache(lat, long)
    Rails.cache.fetch("geohash:#{geohash(lat, long)}")
  end

  def self.geohash(lat, long)
    return '' unless lat && long
    GeoHash.encode(lat, long, 6)
  end

  private

  def cache_geohash
    Rails.cache.write("geohash:#{Venue.geohash(latitude, longitude)}", 'France') # country
  end
end
