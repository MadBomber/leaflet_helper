# LeafletHelper

For those of us who don't want to get our hands dirty writing JavaScript (shutter) this library is for you.  Actually, its for me, but you can use it if you like.  It is a Ruby-wrapper around some basic leaflet.js functions.  It uses either Open Street Map or your account on mapbox.com.  It handles markers on maps and the clustering of those markers.  It supports multiple maps per web page.

This gem has a simple Sinatra-based web application that demonstrates its use.

Launch the example web-app using a bash-based terminal like this:

```bash
lh=`gem which leaflet_helper`
pushd `dirname $lh`/../example
bundle install
./start
# open your web browser to http://localhost:4567
# control-C to stop the example
# popd to return to your current directory
```

## Recent Changes

This is it for a while.  Its doing all I wanted it to do.  I will bump the version to 0.7.7 to reflect the version of the leaflet.js library that this thing uses.  It looks like leaflet will go to version 1.0.0 soon.  When it does I will update this gem to make use of the new versions of the JS libraries.

### v0.7.7.0 - released

* Bumped version to match leaflet

### v0.0.10 - released

* fixed a problem that plauged the multi-map per page defaults collision.
* changed some defaults which may require updates to existing users

### v0.0.9 - released

* added support for cluster_marker to defaults hash on init.

### v0.0.8 - released

* Added basic clusters using the leaflet plugin markercluster
* refactored some code


## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'leaflet_helper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install leaflet_helper

## Usage

Here is [another example](https://github.com/MadBomber/experiments/tree/master/maps) of how to use LeafletHelper with multiple maps on a webpage.

The views/layout.haml and views/index.haml show how to use the leaflet_helper.  Of course you have to require the gem in the main app.rb file in order for it to be available in the views.  This sinatra app also shows how to use markers on top of the main map layers.

Just about all of the methods in this library emit javascript source code.

### LeafletHelper::L.init(options={})

The 'init' method is used to insert the leaflet.js script and leaflet.css stylesheet. It is used in the 'head' part of a webpage.  For example if you are use Sinatra and haml then the 'layout.haml' file might look like this:


```ruby
  %html
    %head
      = LeafletHelper::L.init({ plugins: [:marker_cluster]})
```

The only Leaflet plugin currently supported is [`markercluster`](https://github.com/Leaflet/Leaflet.markercluster)

#### options

The global defaults for all maps are:

```ruby
  plugins:        [],
  latitude:       AREA51.latitude,
  longitude:      AREA51.longitude,
  zoom:           9,
  min_zoom:       2,
  max_zoom:       22,
  cluster_marker: '... see below ...'
```

A `cluster_marker` default is added when the `markercluster` plugin is included.  It is used to create markers for clusters.  The default function is maintained in the file [cluster_icon_create_function.js.erb](https://github.com/MadBomber/leaflet_helper/blob/master/lib/templates/cluster_icon_create_function.js.erb).  This default can be overriden by every map.


### LeafletHelper::L.place_map_here(id='map', options={})

The `place_map_here` method is used to insert the HTML `<div>` tag into the body of a webpage.  This is the HTML container which will host the map image managed by the LeafletJS library.  If is possible to have several map images displayed on the same webpage; HOWEVER, each map image MUST have a different id ... because they MUST be unique ... because they MUST BE DIFFERENT thats why.

```ruby
  %html
    %body
      = LeafletHelper::L.place_map_here('treasure_map', style: 'width: 400px; height: 400px')
```

If you accept all of the defaults then you can just do:

```ruby
  %html
    %body
      = LeafletHelper::L.place_map_here
```

This will result in a `<div id='map'></div>` element being inserted into your HTML code.  Use CSS to style the map anyway you want if you're into that sort of thing.

#### id

Yep, its a string that uniquely identifies the HTML `<div>` component that holds the generated map graphic managed by the LeafletJS javascript library.

#### options

Defaults:

```ruby
  style: "width: 1200px; height: 400px"
```

Of course you could just use some CSS to add anything you want.  But if you are an inline kinda UI/UX newbie then the options are for you.

### LeafletHelper::L.show_map(id="map", options={})

This method is used at the end of the body component of the HTML webpage.  Why? you ask.  Because thats how we did it in the old days to make sure that the entire webpage was loaded before doing stuff on it.  You hotshot javascripters know how its done the "right" way.  I'm sure you have a pull-request ready to go to help out this old back-end geezer.

This method generates javascript source code.  You must explicitly specify the tile layer and wither you want to use markers and wither you want those markers to be clustered. Some typical examples are shown below.

Use Open Street Map as the background tile layer with un-clustered markers:

```ruby
%html
  %body
    Yada Yada Yada
    = LeafletHelper::L.show_map( 'treasure_map', openstreetmap: true, markers: true )
```

Use a `mapbox.com` project as the background tile layer with clustered markers:

```ruby
%html
  %body
    Yo Ho Ho, and a bottle of rum.
    = LeafletHelper::L.show_map( 'treasure_map', mapbox: true, markers: true, cluster: true )
```

#### id

Yep, its a string that uniquely identifies the HTML `<div>` component that holds the generated map graphic managed by the LeafletJS javascript library.

#### options

Defaults:

```ruby
  id:         id,
  map_name:   get_map_name(id),
  markers:    false,
  cluster:    false
```

The method `get_map_name` currently prepends 'lh_' to the map id passed into the method.  You can monkey patch this method to be something different.  For example:

```ruby
require 'leaflet_helper'

module LeafletHelper
  class L
    def self.get_map_name(id)
      'monkey_patching_should_be_avoided_' + id
    end
  end
end
```

What I'd do if I didn't like the default `map_name` is to avoid the howler monkeys and just make my own `map_name` part of the options passed to `show_map` like this:

```ruby
%html
  %body
    Yo Ho Ho, and a few kegs of rum.
    = LeafletHelper::L.show_map( 'treasure_map', map_name: 'hereBeGold', mapbox: true, markers: true, cluster: true )
```

## System Environment Variables

If you are going to use `mapbox.com` as a map tile provider you will need an account on that service.

The following system environment variables are used in loading your scene from mapbox.com:

* MAPBOX_URL
* MAPBOX_USER
* MAPBOX_STYLE_ID
* MAPBOX_ACCESS_TOKEN


## Development

Fork the repo, make a branch for your work, do something, check in your branch then generate a pull request.

Of course if that doesn't work try something else.  I'm not any good at javascript; if you are, send me some pull requests to improve my naive notions.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MadBomber/leaflet_helper.


## License

You want it?  Its yours!
