require 'spec_helper'

describe Admin::DepartmentsController, :type => :controller do

  let(:admin_user) {FactoryGirl.create(:admin_user)}
  let(:department) {FactoryGirl.create(:department)}
  let(:department_1) {FactoryGirl.create(:department)}
  let(:department_2) {FactoryGirl.create(:department)}


  before(:each) do
    session[:id] = admin_user.id
  end

  it "POST #create" do
    department_params = {
      department: {
        name: "User",
        description: "Test Data"
      }
    }
    post :create, department_params
    expect(Department.count).to  eq 1
  end

  it "assigns all get_collections as @departments" do
    [department_1,department_2]
    get :index
    assigns(:departments).should eq([department_1,department_2])
  end

  it "GET #edit" do
    get :edit, {:id => department.id}
    assigns(:department).should eq(department)
  end

  it "GET #show" do
    get :show, {:id => department.id}
    expect(assigns(:department)).to eq(department)
  end

  it "updates the requested department" do
    value = department
    patch :update, {:id => department.id, :department => { :name => "User1", :description =>"Tested data"}}
    expect(value).should_not eq(department)
  end

  it "destroys the requested department" do
    value = department
    expect do
      delete :destroy, {:id => department.id}
    end.to change(Department, :count).by(-1)
  end

end