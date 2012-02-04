module LabelsHelper
  
  # To sort the labels by ranking order
  def sort_by_popularity(a)
    hash = Hash.new
    
    a.each do |l|
      label = Label.find_by_name(l)
      label.watcher_count
      hash[label.name] = label.watcher_count
      
    end  
    
    # Sort hash by value (in descending order)
    hs =  hash.sort_by { |k,v| -v }
    
    a = Array.new
    hs.each do |k,v|
      a << "<a href='/labels/#{k}'>#{k}</a>"
    end
    
    return a.join(", ").html_safe
      
  end

  
end
