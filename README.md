# @maderradar

What is this?

[@maderradar](http://twitter.com/maderradar) attempts to explore the nature of privacy in the age of social media and near-ubiquitous access to digital cameras. Using publicly available data and a few co-conspirators, [@maderradar](http://twitter.com/maderradar) is effectively a crowd-sourced tracking mechanism for a single individual, [Jason Mader](http://twitter.com/@jasonmader). This is also my first twitter bot.

Requirements:
 * [Twitter gem](https://github.com/sferik/twitter)
 * [Geokit gem](http://geokit.rubyforge.org)

How To Use:
 * Clone this repo and edit the settings in `keys.rb.example`.
 * Setup cron jobs to run `maderradar.rb` at relatively frequent intervals.
 * Prepare to annoy the world with 2x the #maderradar notifications!
 * Actually, please don't do any of the stuff in this section.

Gist:
 * `maderradar.rb` searches twitter for instances of the #maderradar tag since the last tweet recorded in `last_tweet`.
 * When a new tweet containing #maderradar is seen, the script pulls any location information from the tweet and does one of the following:
  * If detailed location information is provided (i.e. GPS lat/long), `maderradar.rb` does a lookup with GeoKit and tweets the location of Mader in the following format: ``
  * If rough location information is provided (i.e. city & state), `maderradar.rb` tweets the location of Mader in the following format: ``
  * If no location information is provided, `maderradar.rb` tweets in the following format: ``
 * When the last tweet is sent, `maderradar.rb` records the id of the last tweet seen in `last_tweet`.

Future:
 * This was written prior to some updates to twitter's location API. I have done some updates to the code, but the reverse lookup could be done much better (and maybe without GeoKit).
 * The search function currently uses the REST API. I may eventually switch this to the streaming API.

License:
 * Yup.

Thanks:
 * To Jason Mader ([@jasonmader](http://twitter.com/jasonmader)) for being a good sport and to Alex Bookless ([@BooklessBevs](http://twitter.com/booklessbevs)) for inventing the #maderradar tag.