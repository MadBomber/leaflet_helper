# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "leaflet_helper"
  spec.version       = '0.7.7.0' # first three levels match leaflet
  spec.authors       = ["Dewayne VanHoozer"]
  spec.email         = ["dvanhoozer@gmail.com"]

  spec.summary       = %q{A Ruby-wrapper around some basic leaflet.js functions}
  spec.description   = <<~EOS
    For those of us who don't want to get our hands dirty writing JavaScript (shutter) this library is
    for you.  Actually, its for me, but you can use it if you like.  It is a Ruby-wrapper around some
    basic leaflet.js functions.  It uses either Open Street Map or your account on mapbox.com.  It handles
    markers on maps and the clustering of those markers.  It supports multiple maps per web page.
  EOS

  spec.homepage      = "http://github.com/MadBomber/leaflet_helper"
  spec.license       = "You want it?  Its yours!"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"   #, "~> 1.12"
  spec.add_development_dependency "rake"      #, "~> 10.0"
  spec.add_development_dependency "minitest"  #, "~> 5.0"

end
