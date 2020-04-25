#!/usr/bin/env ruby
#########################################################
###
##  File: app.rb
##  Desc: An example Sinatra app using LeafletHelper 
#

require 'leaflet_helper'

$markers = LeafletHelper::ManageMarkers.new

module TestData

  AREA51_LOCATION   = [37.242, -115.8191]         # Lat, Long
  DELTA             = [15, 15]  # NOTE: expresed as integer of real delta +/- 1.5 in lat, long
                                #       in order to use rand() method

  CODE_WORDS    = [
    "Magic Carpet",
    "Desert Storm",
    "Bayonet Lightning",
    "Valiant Guardian",
    "Urgent Fury",
    "Eagle Claw",
    "Crescent Wind",
    "Spartan Scorpion",
    "Overlord",
    "Rolling Thunder"
  ]

  class << self

    def get_random_codeword
      CODE_WORDS.sample
    end


    def get_random_location( fixed_point=AREA51_LOCATION, delta=DELTA )
      offset  = []
      dir     = rand(2) == 0 ? -1.0 : 1.0
      offset << dir * rand(delta.first).to_f  / 10.0
      dir     = rand(2) == 0 ? -1.0 : 1.0
      offset << dir * rand(delta.last).to_f / 10.0
      point   = fixed_point.each_with_index.map {|v, x| v + offset[x]}

      return { 'lat' => point.first, 'lon' => point.last } 

    end # def get_random_location( fixed_point=AREA51_LOCATION, delta=DELTA )
  end # class < self

end # module TestData

# Generate a consistent set of test markers
$markers.clear
30.times do |x|
  code_word = TestData.get_random_codeword
  location  = TestData.get_random_location
  $markers.add id: code_word,
    lat:    location['lat'],
    lon:    location['lon'],
    html:   <<~EOS
      <h3>Crash ##{x}</h3>
      <p>During #{code_word} rehearsals, programmer error resulted in an unexpected hard landing at this location</p>
    EOS
end


require 'pathname'

ROOT = Pathname.new(__FILE__).realpath.parent

class MissingSystemEnvironmentVariable < RuntimeError; end

unless defined?(APP_BIND)
  raise APP_BIND, "APP_BIND is undefined" if ENV['APP_BIND'].nil?
  APP_BIND = ENV['APP_BIND']
end

unless defined?(APP_PORT)
  raise MissingSystemEnvironmentVariable, "APP_PORT is undefined" if ENV['APP_PORT'].nil?
  APP_PORT = ENV['APP_PORT']
end

require 'json'


require 'sinatra/base'
require 'sinatra/partial'


module APP

  class DemoError < RuntimeError; end

  class App < Sinatra::Base
    register Sinatra::Partial

    set :bind,            APP_BIND
    set :port,            APP_PORT
    set :server,          :puma

    set :haml,            :format => :html5
    set :views,           settings.root + '/views'

    set :partial_template_engine, :haml
  
    configure do
      mime_type :html, 'text/html'
    end


    before do
      content_type :html
    end


    # A marketting landing page
    get '/' do
      haml :index
    end


    # Provide some JSON markers
    # Since everything is randomized, every time the map is
    # changed a new set of markers is generated.
    get '/:map_id/markers' do |map_id|
      content_type :json
      $markers.to_json
    end



############################################################

  end # class App < Sinatra::Base
end # module APP


# APP::App.run!

