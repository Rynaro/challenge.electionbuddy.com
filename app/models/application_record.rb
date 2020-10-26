class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def changed_values
    saved_changes.slice(*trackable_attributes)
  end

  private

  UNTRACKABLE_ATTRS = %w[created_at updated_at].freeze

  def trackable_attributes
    @_trackable_attributes ||= attributes.keys - UNTRACKABLE_ATTRS
  end
end
