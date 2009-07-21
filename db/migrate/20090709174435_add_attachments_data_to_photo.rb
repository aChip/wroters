class AddAttachmentsDataToPhoto < ActiveRecord::Migration
  def self.up

    add_column :photos, :data_file_name, :string
    add_column :photos, :data_content_type, :string
    add_column :photos, :data_file_size, :integer
    add_column :photos, :data_updated_at, :datetime
    add_column :photos, :description, :string
    add_column :photos, :finger_num,:integer
    add_column :photos, :status,:integer
    add_column :photos, :data, :text

  end

  def self.down

    remove_column :photos, :data_file_name
    remove_column :photos, :data_content_type
    remove_column :photos, :data_file_size
    remove_column :photos, :data_updated_at
    remove_column :photos, :finger_num
    remove_column :photos, :status
    remove_column :photos, :file_name
    remove_column :photos, :data
  end
end
