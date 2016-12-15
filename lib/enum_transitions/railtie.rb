require "rails/railtie"

module EnumTransitions
  class Railtie < ::Rails::Railtie
    ActiveSupport.on_load :active_record do
      ::ActiveRecord::Base.extend EnumTransitions
    end
  end
end
