class Image < ApplicationRecord
  belongs_to :item

  has_attached_file :avatar, :styles => { :large => "960x640>", :thumb => "150x150>"  }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
end
