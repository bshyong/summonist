require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe "GET #index" do
    before(:each) do
      FactoryGirl.create_list(:user, 3)
      get :index
    end

    it "returns correct users" do
      user_response = json_response
      expect(user_response.count).to eql User.count
      user_response.each do |user|
        u = User.find(user[:id])
        expect(user[:username]).to eql u.username
        expect(user[:email]).to eql u.email
      end
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do

    context "when the user exists" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        get :show, id: @user.id
      end

      it "returns the correct user" do
        user_response = json_response

        expect(user_response[:id]).to eql @user.id
        expect(user_response[:username]).to eql @user.username
        expect(user_response[:email]).to eql @user.email
      end

      it { should respond_with 200 }
    end

    context "when user doesn't exist" do
      before(:each) do
        get :show, id: "falseid"
      end

      it "returns 404" do
        user_response = json_response
        expect(user_response).to eql({})
      end

      it { should respond_with 404 }
    end
  end

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
        expect(user_response[:username]).to eql @user_attributes[:username]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = { password: "password" }
        post :create, { user: @invalid_user_attributes }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:username]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do

    context "when is successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id,
                         user: { email: "new_email@example.com" } }
      end

      it "renders the json representation for the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eql "new_email@example.com"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id,
                         user: { username: "" } }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:username]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

end
