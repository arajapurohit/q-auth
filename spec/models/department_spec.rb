require 'rails_helper'

RSpec.describe Department, :type => :model do

  let(:department) {FactoryGirl.create(:department)}

  it "should validate the department factory" do
    expect(FactoryGirl.build(:department).valid?).to be true
  end

  it { should validate_presence_of :name }
  it { should allow_value('Testing').for(:name)}
  it { should have_many(:users) }
  it { should have_one(:picture) }

  it "should search the department" do
    Department.create(:name =>"Dep 1", :description =>"Apples");
    Department.create(:name =>"Dep 2", :description =>"Mangoes");
    expect(Department.search("Dep 1")).to be_truthy
    expect(Department.search("Dep 2")).to be_truthy
    expect(Department.search("Dep")).to be_truthy
    expect(Department.search("Apples")).to be_truthy
    expect(Department.search("Mangoes")).to be_truthy
    expect(Department.search("No Data")).to be_empty
  end
end

