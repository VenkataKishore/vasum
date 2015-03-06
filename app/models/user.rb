class User < ActiveRecord::Base
  has_attached_file :profile_pic, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :profile_pic, :content_type => /\Aimage\/.*\Z/
  has_many :payments, dependent: :destroy
  validates :name, presence: true #, :mobile, :address
end
