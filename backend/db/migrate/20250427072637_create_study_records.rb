class CreateStudyRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :study_records do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end
  end
end
