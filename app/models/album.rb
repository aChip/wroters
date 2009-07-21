class Album < ActiveRecord::Base
  cattr_accessor :current_user

  belongs_to :user
  has_many :photos
  validates_presence_of :name

  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes)
    end
  end
  before_create :created_by_user # create only
  before_save :updated_by_user   # both, create and update

  def self.find_del(*args)
    args[1] ||= Hash.new
    args[1].merge!({:limit => 3})
    args[1][:conditions] ||= Hash.new   
    args[1][:conditions].merge!({:user_id=>@@current_user.id})
    super(*args)
  end



  def created_by_user
    self.user_id = @@current_user.id
  end

  def updated_by_user
    self.user_id = @@current_user.id
  end
  
end
