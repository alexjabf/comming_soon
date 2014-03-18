class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.boolean :protected, null: false, default: false, unique: true, index: true
      t.boolean :superadmin, null: false, default: false, unique: true, index: true
      t.boolean :administrator, null: false, default: false, unique: true, index: true
      t.boolean :default_user, null: false, default: false, unique: true, index: true
      t.boolean :guess, null: false, default: false, unique: true, index: true
      t.boolean :custom, null: false, default: true, unique: false, index: true
      t.text :description

      t.timestamps
    end
  end
end
