require "rails_helper"

describe User::ProfileController, :type => :controller do
  it "index" do
    expect(:get => "/user/profile").to route_to(
      :controller => "user/profile",
      :action => "index"
    )
  end

  it "edit" do
    expect(:get => "/user/edit").to route_to(
      :controller => "user/profile",
      :action => "edit"
    )
  end

  it "update" do
    expect(:put => "/user/update").to route_to(
      :controller => "user/profile",
      :action => "update"
    )
  end

end