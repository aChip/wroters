class CreateConfigs < ActiveRecord::Migration
  class Config < ActiveRecord::Base
  end
  
  def self.up
    create_table :configs do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
    config = Config.new(:name=>"app_root",:value=>RAILS_ROOT)
    config.save
  end

  def self.down
    drop_table :configs
  end
end
