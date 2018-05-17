module Filterable
	# extend ActiveSupport::Concern

	# module ClassMethods
		def filter(filtering_params)
			results = self.where(nil)
			filtering_params.each do |key, value|
				results = results.where("#{key}": value) if value.present?
				# results = results.public_send(key, value) if value.present?
			end
			results
		end
	# end
end

      # filtering_params(params).each do |key, value|
      # 	@venues = @venues.where("#{key}": value) if value.present?
      # end