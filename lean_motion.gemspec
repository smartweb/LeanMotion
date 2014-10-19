# -*- encoding: utf-8 -*-
require File.expand_path('../lib/lean_motion/version', __FILE__)

Gem::Specification.new do |s|
  s.name	       = 'lean_motion'
  s.version 	   = LeanMotion::VERSION
  s.date	       = '2014-10-19'

  s.summary 	   = 'Rubymotion wrapper for LeanCloud SDK'
  s.description  = 'Make it more easy to use LeanCloud SDK in RubyMotion. Inspired by ParseModel.'
  s.authors 	   = ["smartweb"]
  s.email	       = 'sam@chamobile.com'
  
  s.files        = Dir.glob("lib/**/*.rb")
  s.files        << "README.md"

  s.homepage 	   = 'http://github.com/smartweb/lean_motion'
  s.license 	   = 'MIT'

  s.executables   << "lean_motion"

  s.add_runtime_dependency("methadone", "~> 1.7")
  s.add_development_dependency("rake", "~> 10.0")
end
