module Api
  module V1
    class PostsController < BaseController
      protected

      def query_params
        params.permit(:user_id, :title)
      end

      def record_params
        params.require(:post).permit(:title, :content).merge(user_id: current_user.id)
      end

      def records
        super.includes(:user)
      end
    end
  end
end