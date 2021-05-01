require 'rails_helper'

RSpec.describe "routines/index", type: :view do
  before(:each) do
    assign(:routines, [
      Routine.create!(),
      Routine.create!()
    ])
  end

  it "renders a list of routines" do
    render
  end
end
