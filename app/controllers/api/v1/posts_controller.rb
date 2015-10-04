module Api
  module V1
    class PostsController < BaseController
      after_action :set_pagination_headers, only: :index

      protected

      def query_params
        params.permit(:user_id, :title)
      end

      def record_params
        params.require(:post).permit(:title, :content).merge(user_id: current_user.id)
      end

      def records
        super.page(params[:page]).includes(:user)
      end

      def set_pagination_headers
        response.headers["X-total"] = records.total_count.to_s
        response.headers["X-offset"] = records.offset_value.to_s
        response.headers["X-limit"] = records.limit_value.to_s
      end
    end
  end
end