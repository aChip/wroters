class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string, :limit => 40
      t.column :name,                      :string, :limit => 100, :default => '', :null => true
      t.column :sex,                       :integer,:default => '1'
      t.column :addr,                      :string, :limit => 120
      t.column :tel,                       :string, :limit => 120
      t.column :birth,                     :date
      t.column :avatar_id,                 :integer

      t.column :email,                     :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime


    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
