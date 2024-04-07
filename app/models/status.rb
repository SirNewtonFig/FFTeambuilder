class Status < ApplicationRecord
  scope :for_ai_values, -> { 
    where(show_priority: true)
      .order(:name)
  }

  class << self
    def default_priorities
      Status.for_ai_values.pluck(:name, :default_priority).to_h.transform_keys(&:parameterize)
    end

    def clear_priorities
      Status.for_ai_values.pluck(:name).map{|key| [key.parameterize, 0] }.to_h
    end
  end
end
