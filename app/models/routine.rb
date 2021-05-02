class Routine < ApplicationRecord
  module Types
    ALL = [
      WORKOUT = "workout",
      DINNER = "dinner"
    ]
  end


  validates :routine_type, presence: true, uniqueness: true
  has_many :activities, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :activities, allow_destroy: true
  
end
# Routine::Types::WORKOUT
# used for model validations
# :inclusion => :in => Types::ALL if I wanted a bank of possible workout types for the user to chose from. 