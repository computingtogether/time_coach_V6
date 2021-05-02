class AddActivityTitleToActivity < ActiveRecord::Migration[6.1]
  def change
    add_column :activities, :activity_title, :string
    add_column :activities, :description, :string
    add_column :activities, :duration, :integer
    add_reference :activities, :routine, foreign_key: true
  end
end
