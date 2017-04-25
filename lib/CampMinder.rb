require "virtus"
require "builder"
require "active_model_serializers"

module CampMinder
  def self.logger=(logger)
    @@logger = logger
  end

  def self.logger
    if defined?(@@logger)
      @@logger
    end
  end

  def self.log(content)
    logger&.info content
  end
end

Dir[File.dirname(__FILE__) + "/CampMinder/**/*.rb"].each { |file| require file }
