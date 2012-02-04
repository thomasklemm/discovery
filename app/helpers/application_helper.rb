module ApplicationHelper
  
  def doturl(ident)
    return ident.gsub(".", "%2E")  
  end
  
end
