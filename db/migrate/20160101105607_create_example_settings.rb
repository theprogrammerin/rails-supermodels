class CreateExampleSettings < ActiveRecord::Migration
  def up
    create_table :example_settings do |t|
      t.string :key, null: false
      t.string :value
      t.string :env, null: false, default: 'development'

      t.timestamps
    end
  end

  def down
    drop_table :example_settings
  end
end
