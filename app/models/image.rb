class Image < ApplicationRecord
	belongs_to :imageable, polymorphic: true, optional: true
	has_attached_file :photo, 
  	styles: { small: "200x200>", thumb: "80x80>" }
	validates_attachment :photo, content_type: { content_type: /\Aimage\/.*\z/ }

end
