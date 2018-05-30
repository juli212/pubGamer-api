class Report < ApplicationRecord
	belongs_to :user
	belongs_to :venue
	enum cat: [:inaccurate_venue]
end
