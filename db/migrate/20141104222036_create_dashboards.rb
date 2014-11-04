class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.string :key
      t.text :data

      t.timestamps
    end
  end
end
