class Contact < ApplicationRecord
	belongs_to :user
	enum cat: [:general]
end
