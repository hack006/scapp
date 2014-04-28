class AddColumnNoteAndExcuseReasonToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :note, :text
    add_column :attendances, :excuse_reason, :string
  end
end
