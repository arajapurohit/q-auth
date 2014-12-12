require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) {FactoryGirl.create(:user)}
  let(:pending_user) {FactoryGirl.create(:pending_user)}
  let(:approved_user) {FactoryGirl.create(:approved_user)}
  let(:blocked_user) {FactoryGirl.create(:blocked_user)}



  context "Factory settings for users" do

    it "should validate the user factories" do
      expect(FactoryGirl.build(:user).valid?).to be true
    end

    it "should validate the user factories" do
      expect(FactoryGirl.build(:pending_user).valid?).to be true
    end

    it "should validate the user factories" do
      expect(FactoryGirl.build(:approved_user).valid?).to be true
    end

    it "should validate the user factories" do
      expect(FactoryGirl.build(:blocked_user).valid?).to be true
    end
  end

  describe User do
    it { should validate_presence_of :name }
    it { should allow_value('Ravi').for(:name )}
    it { should validate_presence_of :username }
    it { should allow_value('RaviShankar').for(:username )}
    it { should validate_presence_of :email }
    it { should allow_value('something@domain.com').for(:email )}
    it { should validate_presence_of :password }
    it { should allow_value('Password@1').for(:password )}
    it { should validate_inclusion_of(:status).in_array(ConfigCenter::User::STATUS_LIST)  }
  end

  it "should validate name lenght" do

      user.name = "sg"*256
      user.valid?
      expect(user.errors[:name].size).to be 1
      expect(user).to be_invalid

      user.name = "s"
      user.valid?
      expect(user.errors[:name].size).to be 1
      expect(user).to be_invalid

      user.name = "Ravi"
      user.valid?
      expect(user.errors[:name].size).to be 0
      expect(user).to be_valid

  end

  it "should validate username lenght" do

      user.username = "sg"*256
      user.valid?
      expect(user.errors[:username].size).to be 1
      expect(user).to be_invalid

      user.username = "s"
      user.valid?
      expect(user.errors[:username].size).to be 1
      expect(user).to be_invalid

      user.username = "RaviShankar"
      user.valid?
      expect(user.errors[:username].size).to be 0
      expect(user).to be_valid
  end

  it "should validate password lenght" do

      user.password = "sgd"*256
      user.valid?
      expect(user.errors[:password].size).to be 2
      expect(user).to be_invalid

      user.password = "sgd"
      user.valid?
      expect(user.errors[:password].size).to be 2
      expect(user).to be_invalid

      user.password = "Password@1"
      user.valid?
      expect(user.errors[:password].size).to be 0
      expect(user).to be_valid
  end


  it "should validate name" do
    # checking valid names
    ["name", "Ravi"].each do |n|
      user.name = n
      value = user.valid?
       expect(value).to be_truthy
    end

    # checking invalid names
    ["n", "m"].each do |n|
      user.name = n
      value = user.valid?
      expect(value).to be_falsy
    end
  end

  it "should validate username" do
    # checking valid usernames
    ["Username_001", "user_name_002"].each do |n|
      user.username = n
      value = user.valid?
       expect(value).to be_truthy
    end

    # checking invalid usernames
    ["user", ""].each do |n|
      user.username = n
      value = user.valid?
      expect(value).to be_falsy
    end
  end

  it "should validate email" do
    # checking valid email
    ["something.123@domain.com", "something_123@domain.com"].each do |n|
      user.email = n
      value = user.valid?
      expect(value).to be_truthy
    end

    # checking invalid email
    ["something.123.domain.com", "something.com"].each do |n|
      user.email = n
      value = user.valid?
      expect(value).to be_falsy
    end
  end

  it "should validate password" do
    # checking valid password
    ["Password@1", "Password@1"].each do |n|
      user.password = n
      value = user.valid?
      expect(value).to be_truthy
    end

    # checking invalid password
    ["Password", "Password"].each do |n|
      user.password = n
      value = user.valid?
      expect(value).to be_falsy
    end
  end

  it "should find the user if email or username matches" do
      user = FactoryGirl.create(:approved_user, name: "Ram", email: "something.123@domain.com", username: "ramuser1")
      User.find_by_email_or_username("something.123@domain.com").should == user
      User.find_by_email_or_username("ramuser1").should == user
      User.find_by_email_or_username("Ram").should be_nil
    end

    it "should search the users" do

    User.create(:name =>"Ram", :email =>"something.123@domain.com");
    User.create(:name =>"Ram1", :email =>"something.1234@domain.com");
    expect(User.search("something.123@domain.com")).to be_truthy
    expect(User.search("Some data")).to be_empty
  end

end


