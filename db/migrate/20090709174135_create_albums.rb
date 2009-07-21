class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.references :user
      t.string :name
      t.text :description
      t.boolean :publish

      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end
