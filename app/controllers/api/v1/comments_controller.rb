module Api
  module V1
    class CommentsController < BaseController
      protected

      def post
        @post ||= Post.find(params[:post_id])
      end

      def query_params
        params.permit(:user_id).merge(post_id: post.id)
      end

      def record_params
        params.require(:comment).permit(:content).merge(user_id: current_user.id, post_id: post.id)
      end

      def records
        super.includes(:user)
      end
    end
  end
end