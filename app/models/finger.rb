class Finger < ActiveRecord::Base
  belongs_to :user

  has_attached_file :fingerdata,
  :styles => {
    :thumb => "50x50#",
#    :large => "640x480#"
#   :url  => "/fingerdoc/:id/:style/:basename.:extension",
#    :path => ":rails_root/public/fingersdoc/:id/:style/:basename.:extension"
  }


  validates_attachment_presence :fingerdata

  validates_attachment_content_type :fingerdata,
  :content_type => ['image/jpeg', 'image/pjpeg', 'image/bmp',
                                   'image/jpg', 'image/png']

end
