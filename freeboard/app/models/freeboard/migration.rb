module Freeboard
  class Migration < ActiveRecord::Migration
    def change
      create_table :freeboard_dashboards do |t|
        t.string :key
        t.text :data

        t.timestamps
      end
    end
  end
end
