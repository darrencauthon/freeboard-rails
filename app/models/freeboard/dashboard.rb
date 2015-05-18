module Freeboard
  class Dashboard < ActiveRecord::Base
    serialize :data, Hash
    serialize :credentials, Hash
  end
end
