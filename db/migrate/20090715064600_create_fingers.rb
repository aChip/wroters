class CreateFingers < ActiveRecord::Migration
  def self.up
    create_table :fingers do |t|
      t.references :user
      t.string :title
      t.text :description
      t.integer :finger_num
      t.string :file_name
      t.text :data
      t.integer :status

      t.string   :fingerdata_file_name
      t.string   :fingerdata_content_type
      t.integer  :fingerdata_file_size
      t.datetime :fingerdata_updated_at

      t.timestamps
    end
    add_index :fingers, :user_id

  end

  def self.down
    drop_table :fingers
  end
end
