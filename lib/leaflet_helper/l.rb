# l.rb
# class L wraps the LeafletJS junk.  Why L? because in
# javashit the LeafletJS uses L for its namespace.

module LeafletHelper
  class L
    JS        = "http://cdn.leafletjs.com/leaflet/v#{LeafletHelper::VERSION::LeafletJS}/leaflet.js"
    CSS       = "http://cdn.leafletjs.com/leaflet/v#{LeafletHelper::VERSION::LeafletJS}/leaflet.css"

    if LeafletHelper::VERSION::MarkerClusterJS.start_with?('0')
      MarkerClusterJS   = "https://raw.githubusercontent.com/Leaflet/Leaflet.markercluster/leaflet-0.7/dist/leaflet.markercluster.js"
      MarkerClusterCSS  = "https://raw.githubusercontent.com/Leaflet/Leaflet.markercluster/leaflet-0.7/dist/MarkerCluster.css"
    else
      MarkerClusterJS   = "https://unpkg.com/leaflet.markercluster@#{LeafletHelper::VERSION::MarkerClusterJS}/dist/leaflet.markercluster.js"
      MarkerClusterCSS  = "https://unpkg.com/leaflet.markercluster@#{LeafletHelper::VERSION::MarkerClusterJS}/dist/MarkerCluster.css"
    end

    # FIXME: Needs to be isolated between maps in a multi-map application.
    #        experiments/maps shows the problem
    @@defaults  = {
      leaflet_helper_base:
      {   # the options from L#init
        plugins:        [],
        latitude:       AREA51.latitude,
        longitude:      AREA51.longitude,
        zoom:           9,
        min_zoom:       2,
        max_zoom:       22
      },
      cluster_marker: {

      }
    }

    class << self

      # intended for the the head section of a web page
      def init(options={})
        @@defaults[:leaflet_helper_base].merge! options

        if  @@defaults[:leaflet_helper_base][:plugins].include?(:cluster)  &&
            @@defaults[:leaflet_helper_base][:cluster_marker].nil?
          @@defaults[:leaflet_helper_base][:cluster_marker] = U.pull_in('cluster_icon_create_function.js.erb')
        end

        return U.pull_in 'head.html.erb', @@defaults[:leaflet_helper_base]
      end # def init


      # intended for the body of a web page
      # can support multiple maps on a page; each
      # map must have a unique id
      def place_map_here(id='map', options={})
        o = {
              style: "width: 1200px; height: 400px"
            }.merge(options)

        div_options = ""

        o.each_pair do |k,v|
          div_options += " #{k.to_s}=" + '"' + v + '"'
        end

        return U.pull_in 'map_div.html.erb', {id: id, parameters: div_options}
      end # def place_map_here(id='map')


      # Intended for the body at the bottom
      # see the example for, er uh, an example
      def show_map(id="map", options={})
        @@defaults[id] = {
                    id:         id,
                    map_name:   get_map_name(id),
                    markers:    false,
                    cluster:    false
                  }.merge(options)

        o = @@defaults[:leaflet_helper_base].merge( @@defaults[id] )

        script = "<script>\n"
        script += U.pull_in 'show_map.js.erb', o
        script += set_view(id, o)

        # SMELL: why can't you have both OSM and Mapbox?
        #        If I renember right there is a way within Mapbox Studio to incorporate
        #        an open street map layer.  There is also this:
        #        http://gis.stackexchange.com/questions/116205/multiple-simultaneous-tilelayers-in-leaflet
        script += add_openstreetmap_layer(id, o)  if o[:openstreetmap] && !o[:mapbox]
        script += add_mapbox_layer(id, o)         if o[:mapbox]        && !o[:openstreetmap]
        script += add_support_for_markers(id, o)  if o[:markers]

        script += "</script>\n"

        return script
      end # def show_map(id="map", options={})


      # Center an existing map to a specific location
      def set_view(id='map', options={})
        @@defaults[id] = {
                    id:         id,
                    map_name:   get_map_name(id)
                  }.merge(options)

        o = @@defaults[:leaflet_helper_base].merge( @@defaults[id] )

        return U.pull_in 'set_view.js.erb', o
      end # def set_view(id='map', options={})


      # The default tile provider is Open Street Map project
      def add_openstreetmap_layer(id="map", options={})
        @@defaults[id] = {
                    id:               id,
                    map_name:         get_map_name(id),
                    openstreetmap:    true,
                    osm_url:          'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    osm_attribution:  'Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors'
                  }.merge(options)

        o = @@defaults[:leaflet_helper_base].merge( @@defaults[id] )

        return U.pull_in 'add_openstreetmap_layer.js.erb', o
      end # def add_openstreetmap_layer(id="map", options={})


      # NOTE: To use mapbox you must have an account
      def add_mapbox_layer(id="map", options={})
        @@defaults[id] = {
                    id:                   id,
                    map_name:             get_map_name(id),
                    mapbox:               true,
                    mapbox_url:           ENV['MAPBOX_URL']           || "https://api.mapbox.com/styles/v1/{mbUser}/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
                    mapbox_user:          ENV['MAPBOX_USER']          || "your.mapbox.user.account",
                    mapbox_style_id:      ENV['MAPBOX_STYLE_ID']      || "your.mapbox.project.id",
                    mapbox_access_token:  ENV['MAPBOX_ACCESS_TOKEN']  || "your.mapbox.access.token",
                    mapbox_attribution:   'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
                  }.merge(options)

        o = @@defaults[:leaflet_helper_base].merge( @@defaults[id] )

        return U.pull_in 'add_mapbox_layer.js.erb', o
      end # def add_mapbox_layer(id="map", options={})


      # Allows for the generation of markers on top of the map
      def add_support_for_markers(id="map", options={})

        clusterMarkerGroupDefaluts = <<~STRING
          {
            showCoverageOnHover:        true, // When you mouse over a cluster it shows the bounds of its markers.
            zoomToBoundsOnClick:        true, // When you click a cluster we zoom to its bounds.
            spiderfyOnMaxZoom:          true, // When you click a cluster at the bottom zoom level we spiderfy it so you can see all of its markers. (Note: the spiderfy occurs at the current zoom level if all items within the cluster are still clustered at the maximum zoom level or at zoom specified by disableClusteringAtZoom option)
            removeOutsideVisibleBounds: true, // Clusters and markers too far from the viewport are removed from the map for performance.
            spiderLegPolylineOptions:   {     // Allows you to specify PolylineOptions to style spider legs.
              weight:   1.5,
              color:    '#222',
              opacity:  0.5
            }
          }
        STRING

        @@defaults[id] = {
                    id:             id,
                    map_name:       get_map_name(id),
                    route:          "#{id}/markers",
                    markers:        true,
                    cluster:        false,
                    cluster_marker: clusterMarkerGroupDefaluts
                  }.merge(options)

        o = @@defaults[:leaflet_helper_base].merge( @@defaults[id] )

        return U.pull_in 'marker_support.js.erb', o
      end # def add_support_for_markers(map_id, map_options)


      # The Javascript container that has the map for this id
      def get_map_name(id="map")
        return "lh_#{id}"
      end



      # LeafletHelper::U needs access to the L's class variable
      def defaults(id)
        @@defaults[id]
      end

    end # class << self
  end # class L
end # module LeafletHelper

