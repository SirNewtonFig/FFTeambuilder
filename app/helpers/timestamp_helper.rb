module TimestampHelper
  def relative_time(timestamp)
    return "#{time_ago_in_words(timestamp)} ago" if timestamp.past?
    
    "in #{time_ago_in_words(timestamp)}"
  end
end
