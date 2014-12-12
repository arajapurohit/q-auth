require "rails_helper"

RSpec.describe Api::V1::MembersController, :type => :controller do

  let!(:ram) { FactoryGirl.create(:approved_user, name: "Ram Chandran") }
  let!(:sita) { FactoryGirl.create(:approved_user, name: "Sita Lakshmi") }
  let!(:lakshman) { FactoryGirl.create(:approved_user, name: "Lakshmana Simhan") }

  let!(:admin) { FactoryGirl.create(:admin_user) }
  let!(:super_admin) { FactoryGirl.create(:admin_user) }

  describe "index" do
    describe "Positive Case" do
      it "should return the list of users for admin" do

        users = [ram, sita, lakshman, admin, super_admin]
        token = ActionController::HttpAuthentication::Token.encode_credentials(admin.auth_token)
        request.env['HTTP_AUTHORIZATION'] = token

        get "index", :format =>:json
        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(true)

        #expect(response_body["data"]["name"]).to  eq("Mohandas Gandhi")
      end
      it "should return the list of users for super admin" do

        users = [ram, sita, lakshman, admin, super_admin]
        token = ActionController::HttpAuthentication::Token.encode_credentials(super_admin.auth_token)
        request.env['HTTP_AUTHORIZATION'] = token

        get "index", :format =>:json
        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(true)

        #expect(response_body["data"]["name"]).to  eq("Mohandas Gandhi")
      end
    end

    describe "Negative Case" do
      it "should not return the list of users without auth token" do

        users = [ram, sita, lakshman, admin, super_admin]

        get "index", :format =>:json
        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to  eq(false)
        expect(response_body["alert"]).to  eq("403 Permission Denied! You don't have permission to perform this action.")

        #expect(response_body["data"]["name"]).to  eq("Mohandas Gandhi")

      end
      it "should not return the list of users for ram" do

        users = [ram, sita, lakshman, admin, super_admin]
        token = ActionController::HttpAuthentication::Token.encode_credentials(ram.auth_token)
        request.env['HTTP_AUTHORIZATION'] = token

        get "index", :format =>:json
        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to  eq(false)
        expect(response_body["alert"]).to  eq("403 Permission Denied! You don't have permission to perform this action.")

        #expect(response_body["data"]["name"]).to  eq("Mohandas Gandhi")

      end
    end
  end

end