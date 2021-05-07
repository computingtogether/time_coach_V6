require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "request list of all users" do
    user = User.create(email: "awesome_user@gmail.com", password: '123456')
    get users_path
    expect(response).to be_successful
    expect(response.body).to include("awesome_user@gmail.com")
  end
end

RSpec.describe TeamsController do
  describe "GET index" do
    it "assigns @teams" do
      team = Team.create
      get :index
      expect(assigns(:teams)).to eq([team])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
