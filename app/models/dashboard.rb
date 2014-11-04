class Dashboard < ActiveRecord::Base
  serialize :data, Hash
end
