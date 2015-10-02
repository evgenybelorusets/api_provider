module Api
  module V1
    class UsersController < BaseController
      protected

      def query_params
        result = params.permit(:first_name, :last_name, :email, :role)
        #enum doesn't work well with string value passed to #where. It just calls #to_i on it
        result[:role] = User.roles[result[:role]] if result[:role].present?
        result.merge(client_application_id: @client_application.id)
      end

      def record_params
        params.require(:user).permit(:first_name, :last_name, :email, :uid, :role).
          merge(client_application_id: @client_application.id)
      end
    end
  end
end