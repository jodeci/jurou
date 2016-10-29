$:.push File.expand_path("../lib", __FILE__)
Gem::Specification.new do |spec|
  spec.name = "jurou"
  spec.version = "0.0.6"
  spec.date = "2016-10-28"
  spec.description = "very early devlopment, use at own risk XD"
  spec.summary = "i18n view helpers"
  spec.authors = ["Tsehau Chao"]
  spec.email = ["jodeci@5xruby.tw"]
  spec.homepage = "https://github.com/jodeci/jurou"
  spec.files = Dir["lib/**/*"]
  spec.license = "MIT"
  spec.add_development_dependency "rspec", "~> 3.0"
end
