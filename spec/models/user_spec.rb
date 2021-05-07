require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation tests' do

    it 'ensures email presence' do
      user = User.new(password: '123456').save
      expect(user).to eq(false)
    end

    it 'ensures password presence' do
      user = User.new(email: "awesome_user@gmail.com").save
      expect(user).to eq(false)
    end

    it 'should save successfully' do
      user = User.new(email: "awesome_user@gmail.com", password: '123456').save
      expect(user).to eq(true)
    end
  end
end
