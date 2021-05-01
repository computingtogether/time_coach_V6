require 'rails_helper'

RSpec.describe "routines/show", type: :view do
  before(:each) do
    @routine = assign(:routine, Routine.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
