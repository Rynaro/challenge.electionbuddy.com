module Auditable
  extend ActiveSupport::Concern

  included do
    has_many :audits, as: :auditable

    after_create do |instance|
      audit_it(instance, :create)
    end

    after_update do |instance|
      audit_it(instance, :update)
    end

    def audit?
      trackable_attributes.present?
    end
  end

  private

  def audit_it(instance, action)
    return unless instance.audit?

    Audit.trail!(instance, action)
  end
end
