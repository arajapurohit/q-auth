require 'rails_helper'

describe Admin::DepartmentsController, :type => :controller do

  let(:admin_user) {FactoryGirl.create(:admin_user)}
  let(:super_admin_user) {FactoryGirl.create(:super_admin_user, :name => "testuser", :username =>"username", :email =>"abcd@yopmail.com", :biography => "Hi this is lorem ipsum", :password =>  ConfigCenter::Defaults::PASSWORD, :password_confirmation =>  ConfigCenter::Defaults::PASSWORD, :user_type =>"super_admin" )}
  let(:department) {FactoryGirl.create(:department)}

  before(:each) do
    session[:id] = super_admin_user.id
  end

  it "POST #create" do
    department_params = {
      department: {
        name: "Department Name",
        description: "Department responsibilities"
      }
    }
    post :create, department_params
    expect(Department.count).to  eq 1
  end

  it "assigns all get_collections as @departments" do
    get :index
    assigns(:departments).should eq([department])
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
    patch :update, {:id => department.id, :department => { :name => "Dep1", :description =>"Some Responsibilities"}}
    expect(value).should_not eq(department)
  end

  it "destroys the requested department" do
    value = department
    expect do
      delete :destroy, {:id => department.id}
    end.to change(Department, :count).by(-1)
  end
end

