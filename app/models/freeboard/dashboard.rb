module Freeboard
  class Dashboard < ActiveRecord::Base
    serialize :data, Hash
    serialize :credentials, Hash

    def requires_authentication?
      credentials.keys.any?
    end
  end
end
