require 'rails_helper'

RSpec.describe Routine, type: :model do
  it 'ensures routine_type presence' do
    routine = Routine.new().create!
    expect(routine).to eq(false)
  end

  it 'should save successfully' do
    routine = Routine.new(routine_type: "workout").create!
    expect(routine).to eq(true)
  end
end
