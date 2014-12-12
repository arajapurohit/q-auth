module Api
  module V1
    class BaseController < ApplicationController

      include ApiHelper
      include ParamsParserHelper

      before_filter :require_auth_token

    end
  end

end
