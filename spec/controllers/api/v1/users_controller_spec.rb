require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) { request.headers['Accept'] = "application/vnd.summonist.v1" }

  describe "GET #index" do
    before(:each) do
      FactoryGirl.create_list(:user, 3)
      get :index, format: :json
    end

    it "returns users" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response.count).to eql User.count
      user_response.each do |user|
        u = User.find(user[:id])
        expect(user[:username]).to eql u.username
        expect(user[:email]).to eql u.email
      end
    end

    it { should respond_with 200 }
  end
end
