require 'rails_helper'

RSpec.describe "routines/new", type: :view do
  before(:each) do
    assign(:routine, Routine.new())
  end

  it "renders new routine form" do
    render

    assert_select "form[action=?][method=?]", routines_path, "post" do
    end
  end
end
