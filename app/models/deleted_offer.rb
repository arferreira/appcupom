class DeletedOffer < Offer
	default_scope where(:deleted => 1)
end
