# leaflet_helper.rb
#
# If you are a front-end developer and a Javascript guru this will 
# make you laught.  If you are a back-end big-data AI do-er of amazing
# things then this library might be of some use to you.  It allows you 
# to but maps onto a web-page using simple frameworks.  No more NodeJS
# or Rails.  Use some simple sinatra-based haml pages and voila you got maps.
#
# Makes use of these system environment variables when using
# the method Mapbox.com as a tile provider:
#
#   MAPBOX_URL
#   MAPBOX_USER
#   MAPBOX_STYLE_ID
#   MAPBOX_ACCESS_TOKEN

require 'erb'
require 'pathname'

# Just as good a default as any other ...
AREA51 = Struct.new('Location', :latitude, :longitude).new
AREA51.latitude   = 37.235
AREA51.longitude  = -115.811111

require 'leaflet_helper/string_template'  # Lets do simple string templates
require 'leaflet_helper/manage_markers'   # Lets keep track of some markers
require 'leaflet_helper/u'                # a utility class
require 'leaflet_helper/l'                # wrapper class for LeafletJS


module LeafletHelper
  TEMPLATES = Pathname.new(__FILE__).parent + 'templates'
end # module LeafletHelper
