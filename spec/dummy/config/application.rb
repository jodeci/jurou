require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "jurou"

module Dummy
  class Application < Rails::Application
    config.i18n.default_locale = :"zh-TW"
  end
end

