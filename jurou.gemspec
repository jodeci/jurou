# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jurou/version"

Gem::Specification.new do |spec|
  spec.name = "jurou"
  spec.version = Jurou::VERSION
  spec.date = "2016-10-28"
  spec.description = "very early devlopment, use at own risk XD"
  spec.summary = "i18n view helpers"
  spec.authors = ["Tsehau Chao"]
  spec.email = ["jodeci@5xruby.tw"]
  spec.homepage = "https://github.com/jodeci/jurou"
  spec.files = Dir["lib/**/*", "LICENSE.txt", "README.md"]
  spec.license = "MIT"

  spec.add_dependency "activesupport", "~> 5.0"
  spec.add_dependency "shikigami", "~> 0.1"
end
