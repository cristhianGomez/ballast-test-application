module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!, except: %i[index show]

      private

      def current_user
        @current_user ||= super
      end
    end
  end
end
