class CreateWorkoutSessions < ActiveRecord::Migration
  def change
    create_table :workout_sessions do |t|
      t.datetime :workout_date
      t.string :name
      t.text :notes
      t.text :timestamps
      t.text :readings
      t.string :workout
      t.timestamps
    end
  end
end
