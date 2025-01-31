module TimestampHelper
  def relative_time(timestamp)
    return "#{time_ago_in_words(timestamp)} ago" if timestamp.past?
    
    "in #{time_ago_in_words(timestamp)}"
  end

  def relative_time2(timestamp)
    diff = timestamp - Time.current

    d = diff.abs / 86400
    h = d.remainder(1) * 24
    m = h.remainder(1) * 60
    s = m.remainder(1) * 60
    
    parts = {d: d.to_i, h: h.to_i, m: m.to_i, s: s.to_i}

    return 'now' if parts.values.all?(&:zero?)

    output = []
    output << 'in ' if diff.positive?

    parts.each do |k,v|
      break if v.zero? && output.present?
      next if v.zero?

      output << "#{v}#{k}"
      break if output.length > 1
    end

    output << ' ago' if diff.negative?
    output.join
  end
end
