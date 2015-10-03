module Api
  module V1
    class BaseController < ActionController::Base
      respond_to :json

      rescue_from CanCan::AccessDenied do
        head :forbidden
      end

      rescue_from ActiveRecord::RecordNotFound do
        head :not_found
      end

      before_action :authenticate

      def create
        authorize! :create, record_class
        if record.save
          render :show, status: :created
        else
          render json: { errors: record.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, record
        if record.update_attributes(record_params)
          render :show
        else
          render json: { errors: record.errors } , status: :unprocessable_entity
        end
      end

      def index
        authorize! :read, record_class
        respond_with records
      end

      def show
        authorize! :read, record
        respond_with record
      end

      def destroy
        authorize! :destroy, record
        record.destroy
        head :no_content
      end

      protected

      def record_class
        controller_name.classify.constantize
      end

      def record
        @record ||= params[:id] ? record_class.find(params[:id]) : record_class.new(record_params)
      end
      helper_method :record

      def records
        @records ||= record_class.where(query_params)
      end
      helper_method :records

      def current_user
        @current_user ||= User.find_by_uid(params[:user_uid]) || User.guest
      end

      def authenticate
        authenticate_with_http_basic do |key, secret|
          @client_application = ClientApplication.find_by_key_and_secret(key, secret)

          unless @client_application
            head :unauthorized
          end
        end
      end
    end
  end
end