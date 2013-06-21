module AdministratorsHelper
  
  def get_category(partner)
    categories = PartnerCategory.find_by_partner_id(partner.id, :limit => 1)
    #p '#######################'
    #p partner.id.to_s + ' - ' + partner.name.to_s
    #p categories.category.name
    
    if categories == nil
      return 'N/A'
    else 
      return categories.category.name
    end
  end
  
end
