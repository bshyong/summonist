require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:email) }

  it { should be_valid }
end
