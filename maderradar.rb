#!/usr/bin/env ruby
require 'twitter'
require 'geokit'
require 'fileutils'

require_relative 'keys'

include Geokit::Geocoders

twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.oauth_token = OAUTH_TOKEN
  config.oauth_token_secret = OAUTH_TOKEN_SECRET
end

last_tweet = "#{File.dirname(__FILE__)}/last_tweet"

#Read last processed tweet id from file and save to variable
last_tweet_id = File.read(last_tweet).to_i

changed = false

begin
  twitter.search('#maderradar', :since_id => last_tweet_id).collect do |status|
    # Saves the most recent tweet id to file
    if last_tweet_id < status.id
      last_tweet_id = status.id
      changed = true
    end

    if !status.retweet?
      if status.geo?
        res = GoogleGeocoder.reverse_geocode([status.geo.coordinates[0],status.geo.coordinates[1]])
        if res.street_address == nil
          res.street_address = "an unknown location"
        end
        twitter.update("Mader spotted by @#{status.user.screen_name} near #{res.street_address}. Find him on a map: http://maps.google.com/maps?q=#{status.geo.coordinates[0]},+#{status.geo.coordinates[1]}", :in_reply_to_status_id => status.id)
      elsif status.place?
        twitter.update("Mader spotted by @#{status.user.screen_name} in #{status.place.full_name}. Read more: http://twitter.com/#{status.user.screen_name}/status/#{status.id}")
      else
        twitter.update("Mader spotted by @#{status.user.screen_name}, but location information was not provided. Read more: http://twitter.com/#{status.user.screen_name}/status/#{status.id}", :in_reply_to_status_id => status.id)
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