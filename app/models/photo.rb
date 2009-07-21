class Photo < ActiveRecord::Base
  belongs_to :album
  
  has_attached_file :data,
  :styles => {
    :thumb => "50x50#",
#    :large => "640x480#"
      #:url  => "/assets/products/:id/:style/:basename.:extension",   
      #:path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"      
  }

      
  validates_attachment_presence :data

  validates_attachment_content_type :data, 
  :content_type => ['image/jpeg', 'image/pjpeg', 'image/bmp',
                                   'image/jpg', 'image/png']

end
