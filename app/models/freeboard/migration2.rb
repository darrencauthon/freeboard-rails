module Freeboard
  class Migration2 < ActiveRecord::Migration
    def change
      add_column :freeboard_dashboards, :credentials, :text
    end
  end
end
