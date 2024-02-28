# app/models/concerns/moderable.rb
module Moderable
  extend ActiveSupport::Concern

  included do
    before_save :moderate_if_necessary
  end

  class_methods do
    attr_reader :moderated_attributes

    def moderates(*attributes)
      @moderated_attributes = attributes
    end
  end

  private

  def moderate_if_necessary
    self.class.moderated_attributes.each do |attribute|
      next unless send("#{attribute}_changed?")
      content = send(attribute)
      response = ModerationService.check_content(content)
      self.is_accepted = response[:is_accepted]
    end
  end
end
