#!/usr/bin/env ruby
require 'twitter'
require 'geokit'
require 'fileutils'

include Geokit::Geocoders

#twitter
YOUR_CONSUMER_KEY = ''
YOUR_CONSUMER_SECRET = ''
YOUR_OAUTH_TOKEN = ''
YOUR_OAUTH_TOKEN_SECRET = ''

Twitter.configure do |config|
  config.consumer_key = YOUR_CONSUMER_KEY
  config.consumer_secret = YOUR_CONSUMER_SECRET
  config.oauth_token = YOUR_OAUTH_TOKEN
  config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end

last_tweet = "#{File.dirname(__FILE__)}/last_tweet"

#Read last processed tweet id from file and save to variable
last_tweet_id = File.read(last_tweet).to_i

changed = false

loop do
  begin
    Twitter.search('#maderradar', :since_id => last_tweet_id).results.map do |status|
      # Saves the most recent tweet id to file
      if last_tweet_id < status.id
        last_tweet_id = status.id
        changed = true
      end

      if !status.retweet?
        if status.geo != nil
          res = GoogleGeocoder.reverse_geocode([status.geo.latitude,status.geo.longitude])
          if res.street_address == nil
            res.street_address = "an unknown location"
          end
          Twitter.update("Mader spotted by @#{status.from_user} near #{res.street_address}. Find him on a map: http://maps.google.com/maps?q=#{status.geo.latitude},+#{status.geo.longitude}", :in_reply_to_status_id => status.id)

        else
          Twitter.update("Mader spotted by @#{status.from_user}, but location information was not provided. Read more: http://twitter.com/#{status.from_user}/status/#{status.id}", :in_reply_to_status_id => status.id)
        end
      end

    end
  rescue Exception => e
    p e
  end

  #Save most recent tweet ID to file
  if changed == true
    File.new(last_tweet, "w")

    File.open(last_tweet, "a") do |f|
      f.write last_tweet_id
    end
    changed = false
  end

  sleep 30

end

