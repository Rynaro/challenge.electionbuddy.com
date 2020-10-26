class Audit < ApplicationRecord
  belongs_to :user
  belongs_to :auditable, polymorphic: true

  def create?
    transaction_scope == 'create'
  end

  def update?
    transaction_scope == 'update'
  end

  def self.trail!(entity, action)
    data_changes = entity.changed_values unless action == :create
    create!(
      user: Current.user,
      auditable: entity,
      data_changes:  data_changes || {},
      transaction_scope: action
    )
  end
end
