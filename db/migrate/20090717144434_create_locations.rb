class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.integer :user_id
      t.float :lat
      t.float :long
      t.string :memo

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
