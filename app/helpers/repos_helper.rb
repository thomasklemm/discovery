module ReposHelper
  
  # Returns a class name that should be given an appropriate color in css
  def activity_wheel(last_updated)
    td = Time.now - last_updated
    
    if td < 7*24*60*60
      return "lt7"
    elsif td < 14*24*60*60
      return "lt14"
    elsif td < 31*24*60*60
      return "lt31"
    elsif td < 62*24*60*60
      return "lt62"
    elsif td < 93*24*60*60
      return "lt93"
    elsif td < 183*24*60*60
      return "lt183"
    elsif td < 365*24*60*60
      return "lt365"
    elsif td > 365*24*60*60
      return "gt365"
    else
      return "error"
    end
  end
  
end
