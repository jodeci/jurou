require "jurou/view_helpers"
module Jurou
  class Railtie < Rails::Railtie
    initializer "jurou.view_helpers" do
      ActiveSupport.on_load( :action_view ){ include Jurou::ViewHelpers } 
    end
  end
end
