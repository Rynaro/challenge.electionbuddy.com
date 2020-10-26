class CreateAudits < ActiveRecord::Migration[6.0]
  def change
    create_table :audits do |t|
      t.json :data_changes
      t.references :user, null: false, foreign_key: true
      t.references :auditable, polymorphic: true, null: false
      t.string :transaction_scope

      t.timestamps
    end
  end
end
