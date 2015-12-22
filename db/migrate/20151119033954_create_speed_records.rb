class CreateSpeedRecords < ActiveRecord::Migration
  def change
    create_table :speed_records do |t|
      t.datetime :record_time
      t.float :speed
      t.timestamps
    end
  end
end
