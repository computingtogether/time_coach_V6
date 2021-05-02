class Activity < ApplicationRecord
  validates :activity_title, :presence => true
  validates :duration, numericality: { only_integer: true, greater_than: 0 }
  belongs_to :routine

end
