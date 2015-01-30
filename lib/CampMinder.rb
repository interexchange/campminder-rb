require "virtus"
require "builder"
require "active_model_serializers"

module CampMinder
end

Dir[File.dirname(__FILE__) + "/CampMinder/**/*.rb"].each { |file| require file }
