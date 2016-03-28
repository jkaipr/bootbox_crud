class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :name
      t.integer :width
      t.integer :height
      t.integer :depth

      t.timestamps null: false
    end
  end
end
