require "virtus"
require "builder"
require "active_model_serializers"

module CampMinder
  def self.logger=(logger)
    @@logger = logger
  end
  def self.log(content)
    if @@logger
      @@logger.info content
    end
  end
end

Dir[File.dirname(__FILE__) + "/CampMinder/**/*.rb"].each { |file| require file }
