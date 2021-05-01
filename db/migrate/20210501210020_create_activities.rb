class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.string :activity_title
      t.string :description
      t.integer :duration
      t.references :routine, :foreign_key => true
      t.timestamps
    end
  end
end
