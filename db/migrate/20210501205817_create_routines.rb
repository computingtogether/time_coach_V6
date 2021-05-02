class CreateRoutines < ActiveRecord::Migration[6.1]
  def change
    create_table :routines do |t|
      t.references :user, :foreign_key => true
      t.string :routine_type
      t.timestamps
    end
  end
end
