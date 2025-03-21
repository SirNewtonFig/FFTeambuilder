module BypassAuth
  extend ActiveSupport::Concern

  included do
    def bypass_auth?
      true
    end
  end
end