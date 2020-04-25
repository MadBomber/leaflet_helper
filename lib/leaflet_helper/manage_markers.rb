# manage_markers.rb

require 'json'

module LeafletHelper

  # Marker encapsulates an Array of Hashes where each Hash
  # is a marker structure which can be used to add content to
  # a LeafletJS-managed map image.
  class ManageMarkers

    # Manage an Array of Hashes
    def initialize()
      @markers = Array.new
    end # def initialize


    # a marker consists of an identification (not unique),
    # a location expressed as decimal latitude longitude and
    # an html component.
    def add(id:, lat:, lon:, html: '<p>Anything with {variable} markers to be replaced by data contents.</p>', data:{})
      @markers << {
        id:   id,
        lat:  lat,
        lon:  lon,
        html: data.empty? ? html : StringTemplate.new(html).use(data)
      }
    end
    alias :insert :add
    alias :<< :add
    alias :push :add


    # Remove all marker entries that have the given id
    def remove(id)
      return() if @markers.empty?
      @markers.each_index do |x|
        @markers[x] = nil if id == @markers[x][:id]
      end
      @markers.compact!
    end
    alias :delete :remove
    alias :rm :remove
    alias :pull :remove


    # Replace the html string's variables with values from a hash
    def replace_with(id, a_hash)
      return() if @markers.empty?
      @markers.each_index do |x|
        if :all == id || id == @markers[x][:id]
          @markers[x][:html] = StringTemplate.new(@markers[x][:html]).use(a_hash)
        end
      end
    end

    def replace_all_with(a_hash)
      replace_with(:all, a_hash)
    end


    # Clear out the array so we can start over
    def clear
      @markers = Array.new
    end
    alias :clean :clear


    # Turn the array of markers into a JSON structure
    def to_json
      @markers.to_json
    end

  end # class ManageMarkers
end # module LeafletHelper



__END__

# TODO: move some of this into the example sinatra app

Example: One Map

my_map = LeafletHelper::ManageMarkers.new

my_map.add  id:   'Secret Place', 
            lat:  AREA51.latitude, 
            lon:  AREA51.longitude, 
            html: <<~EOS
              <h3>Area 51</h3>
              <img src='ufo.png'>
              <p>For Sale <em>Low Mileage</em>, owner is medicated.  Must see to appriciate!  Come by after sunset; beware of guards!</p>
            EOS

puts my_map.to_json #=> [{"id":"Secret Place","lat":37.235,"lon":-115.811111,"html":"<h3>Area 51</h3>\n<img src='ufo.png'>\n<p>For Sale <em>Low Mileage</em>, owner is modicated.  Must see to appriciate!  Come by after sunset; beware of guards</p>\n"}]


Example: Multiple Maps

markers = Hash.new(LeafletHelper::ManageMarkers.new)

markers['map'].add  id:   'Secret Place', 
            lat:  AREA51.latitude, 
            lon:  AREA51.longitude, 
            html: <<~EOS
              <h3>Area 51</h3>
              <img src='ufo.png'>
              <p>For Sale <em>Low Mileage</em>, owner is modivated.  Must see to appriciate!  Come by after sunset; beware of guards!</p>
            EOS

markers['map2'].add  id:   'Secret Place', 
            lat:  AREA51.latitude, 
            lon:  AREA51.longitude, 
            html: <<~EOS
              <h3>Area 51</h3>
              <img src='ufo.png'>
              <p>For Sale <em>Low Mileage</em>, owner is modivated.  Must see to appriciate!  Come by after sunset; beware of guards!</p>
            EOS

Example: Using StringTemplate woth one map

my_map = LeafletHelper::ManageMarkers.new

# You can setup a complex string template
template = <<~EOS
  <h3>{title}</h3>
  <em>{classification}<em>
  <img src="{thumbnail}">
  <a href="http://{image}"">Show Full Image</a>
  {comments}
EOS

# Then use a hash to populate the template with data
data = {
  title:          'Actual Flying Saucer Crash Remains',
  classification: "Above TS; Q; TK; SAP: MJ12; NTK: not you; NOFORN; SCI: Silliness",
  thumbnail:      "images/p123_150x150.png",
  image:          "images/p123.png"
}

my_map.add  id:   'Secret Place', 
            lat:  AREA51.latitude, 
            lon:  AREA51.longitude, 
            html: template,
            data: data

my_map.replace_all_with {comments: "<em>You never saw this.  I was never here.</em>"}


