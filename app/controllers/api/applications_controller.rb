module Api
    class ApplicationsController < ApplicationController

        def index
            applications = Application.all
            render json:{applications: applications}
        end

        def show
            application = Application.find(params[:id])
            render json:{application: application}
        end

        def create
            application = Application.new(application_params)
            application.token = encode_token({name: application.name})
            if application.save
                render json: {application: application}
            else
                render json: {message: 'Internal Server Error'}
            end
        end

        def destroy
            application = Application.find(params[:id])
            application.destroy
        end

        private

        def application_params
            params.permit(:name)
        end
    end
end