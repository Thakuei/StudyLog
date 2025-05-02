class ChangeEndTimeNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :study_records, :end_time, true
  end
end
