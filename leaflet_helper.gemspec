# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require_relative 'lib/version.rb'

Gem::Specification.new do |spec|
  spec.name          = "leaflet_helper"
  spec.version       = LeafletHelper::VERSION::GEM
  spec.authors       = ["Dewayne VanHoozer"]
  spec.email         = ["dvanhoozer@gmail.com"]

  spec.summary       = %q{A Ruby-wrapper around some basic leaflet.js functions}
  spec.description   = <<~EOS
    DO NOT USE.... its a broken toy and I do not have the motivation to fix it.
    For those of us who don't want to get our hands dirty writing JavaScript (shutter) this library is
    for you.  Actually, its for me, but you can use it if you like.  It is a Ruby-wrapper around some
    basic leaflet.js functions.  It uses either Open Street Map or your account on mapbox.com.  It handles
    markers on maps and the clustering of those markers.  It supports multiple maps per web page.
  EOS

  spec.homepage      = "http://github.com/MadBomber/leaflet_helper"
  spec.license       = "You want it?  Its yours!"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"

end
